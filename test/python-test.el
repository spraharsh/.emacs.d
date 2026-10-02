;;; python-test.el --- Python workflow regression checks -*- lexical-binding: t -*-

;; Run: emacs --batch -Q -l test/python-test.el -f ert-run-tests-batch-and-exit
(require 'ert)
(require 'cl-lib)
(require 'json)
(require 'package)
(package-initialize)
(require 'use-package)
(add-to-list 'load-path (expand-file-name "config" user-emacs-directory))
(require 'init-python)

(defconst python-test--python (executable-find "python3"))

(defmacro python-test--with-directory (&rest body)
  "Run BODY in a temporary directory, then remove it."
  (declare (indent 0))
  `(let ((directory (make-temp-file "emacs-python-test-" t)))
     (unwind-protect
         (let ((default-directory (file-name-as-directory directory)))
           ,@body)
       (delete-directory directory t))))

(defun python-test--environment (root)
  "Create an environment at ROOT using the existing Python executable."
  (make-directory (expand-file-name "bin" root) t)
  (make-symbolic-link python-test--python (expand-file-name "bin/python" root))
  root)

(defun python-test--wait (process)
  "Wait briefly for PROCESS and assert successful completion."
  (let ((deadline (+ (float-time) 10)))
    (should process)
    (while (and (process-live-p process) (< (float-time) deadline))
      (accept-process-output process 0.05))
    (should-not (process-live-p process))
    (should (= 0 (process-exit-status process)))))

(ert-deftest python-uses-builtin-base-mode ()
  (should (featurep 'python))
  (should (provided-mode-derived-p 'python-mode 'python-base-mode))
  (when (fboundp 'python-ts-mode)
    (should (provided-mode-derived-p 'python-ts-mode 'python-base-mode))))

(ert-deftest python-root-prefers-nearest-pyproject ()
  (python-test--with-directory
    (let* ((outer directory)
           (inner (expand-file-name "nested" outer))
           (default-directory (file-name-as-directory
                               (expand-file-name "src" inner))))
      (make-directory default-directory t)
      (write-region "" nil (expand-file-name "pyproject.toml" outer) nil 'silent)
      (write-region "" nil (expand-file-name "pyproject.toml" inner) nil 'silent)
      (cl-letf (((symbol-function 'project-current) (lambda (&rest _) '(test)))
                ((symbol-function 'project-root) (lambda (_) outer)))
        (should (equal (file-name-as-directory inner)
                       (file-name-as-directory (praharsh-python-project-root))))
        (delete-file (expand-file-name "pyproject.toml" inner))
        (delete-file (expand-file-name "pyproject.toml" outer))
        (should (equal (file-name-as-directory outer)
                       (file-name-as-directory (praharsh-python-project-root)))))
      (cl-letf (((symbol-function 'project-current) (lambda (&rest _) nil)))
        (should (equal default-directory
                       (file-name-as-directory (praharsh-python-project-root))))))))

(ert-deftest python-environments-are-local-and-explicit-selection-wins ()
  (python-test--with-directory
    (let* ((project-a (expand-file-name "a" directory))
           (project-b (expand-file-name "b" directory))
           (env-a (python-test--environment (expand-file-name ".venv" project-a)))
           (env-b (python-test--environment (expand-file-name "venv" project-b)))
           (explicit (python-test--environment (expand-file-name "explicit env" directory)))
           (global-path (copy-sequence (default-value 'exec-path)))
           (global-env (copy-sequence (default-value 'process-environment)))
           (buffer-a (generate-new-buffer " python-test-a"))
           (buffer-b (generate-new-buffer " python-test-b")))
      (dolist (root (list project-a project-b))
        (write-region "" nil (expand-file-name "pyproject.toml" root) nil 'silent))
      ;; Both directories exist: .venv must win over venv.
      (python-test--environment (expand-file-name "venv" project-a))
      (unwind-protect
          (progn
            (with-current-buffer buffer-a
              (setq default-directory (file-name-as-directory project-a))
              (praharsh-python-setup-environment)
              (should (equal python-shell-interpreter (expand-file-name "bin/python" env-a)))
              (should (equal lsp-pyright-python-executable-cmd python-shell-interpreter))
              (should (equal dap-python-executable python-shell-interpreter))
              (should (equal (directory-file-name python-shell-virtualenv-root) env-a))
              (should (equal (getenv "VIRTUAL_ENV") env-a))
              (should (equal (directory-file-name (car exec-path))
                             (expand-file-name "bin" env-a))))
            (with-current-buffer buffer-b
              (setq default-directory (file-name-as-directory project-b))
              (praharsh-python-setup-environment)
              (should (equal python-shell-interpreter (expand-file-name "bin/python" env-b))))
            (with-current-buffer buffer-a
              (should (equal python-shell-interpreter (expand-file-name "bin/python" env-a)))
              (setq-local praharsh-python-environment explicit)
              (praharsh-python-setup-environment)
              (should (equal python-shell-interpreter (expand-file-name "bin/python" explicit)))
              (should (equal (getenv "VIRTUAL_ENV") explicit))
              (should-not (member (expand-file-name "bin" env-a) exec-path)))
            (with-current-buffer buffer-b
              (should (equal (getenv "VIRTUAL_ENV") env-b)))
            (should (equal (default-value 'exec-path) global-path))
            (should (equal (default-value 'process-environment) global-env)))
        (kill-buffer buffer-a)
        (kill-buffer buffer-b)))))

(ert-deftest python-inherits-valid-environments-and-falls-back-to-path ()
  (python-test--with-directory
    (let* ((virtual (python-test--environment (expand-file-name "virtual" directory)))
           (conda (python-test--environment (expand-file-name "conda" directory)))
           (process-environment (copy-sequence process-environment)))
      (cl-letf (((symbol-function 'project-current) (lambda (&rest _) nil)))
        (setenv "VIRTUAL_ENV" virtual)
        (setenv "CONDA_PREFIX" conda)
        (with-temp-buffer
          (praharsh-python-setup-environment)
          (should (equal python-shell-interpreter (expand-file-name "bin/python" virtual))))
        (setenv "VIRTUAL_ENV" (expand-file-name "missing" directory))
        (with-temp-buffer
          (praharsh-python-setup-environment)
          (should (equal python-shell-interpreter (expand-file-name "bin/python" conda))))
        (setenv "VIRTUAL_ENV" nil)
        (setenv "CONDA_PREFIX" nil)
        (with-temp-buffer
          (praharsh-python-setup-environment)
          (should (equal python-shell-interpreter python-test--python))
          (should-not python-shell-virtualenv-root))))))

(ert-deftest python-invalid-explicit-environment-errors-without-global-changes ()
  (python-test--with-directory
    (let ((global-path (copy-sequence (default-value 'exec-path)))
          (global-env (copy-sequence (default-value 'process-environment))))
      (with-temp-buffer
        (setq-local praharsh-python-environment (expand-file-name "missing" directory))
        (should-error (praharsh-python-setup-environment) :type 'user-error))
      (should (equal (default-value 'exec-path) global-path))
      (should (equal (default-value 'process-environment) global-env)))))

(ert-deftest python-module-commands-use-selected-environment-and-project-root ()
  (python-test--with-directory
    (let* ((environment (python-test--environment (expand-file-name "env with space" directory)))
           (python (expand-file-name "bin/python" environment))
           (source (expand-file-name "src" directory))
           captured)
      (make-directory source)
      (write-region "" nil (expand-file-name "pyproject.toml" directory) nil 'silent)
      (with-temp-buffer
        (setq default-directory (file-name-as-directory source))
        (setq-local praharsh-python-environment environment)
        (cl-letf (((symbol-function 'compilation-start)
                   (lambda (command &rest _)
                     (setq captured (list command default-directory
                                          (getenv "VIRTUAL_ENV") (car exec-path)))
                     (current-buffer))))
          (praharsh-python-test)
          (should (equal (car captured) (concat (shell-quote-argument python) " -m pytest")))
          (should (equal (cadr captured) (file-name-as-directory directory)))
          (should (equal (nth 2 captured) environment))
          (should (equal (directory-file-name (nth 3 captured)) (expand-file-name "bin" environment)))
          (praharsh-python-jupyter)
          (should (equal (car captured) (concat (shell-quote-argument python) " -m jupyterlab --no-browser")))
          (should (equal (cadr captured) (file-name-as-directory directory)))
          (cl-letf (((symbol-function 'read-shell-command)
                     (lambda (_prompt initial &rest _)
                       (should (equal initial (concat (shell-quote-argument python) " -m pytest")))
                       "printf edited-command")))
            (praharsh-python-test t)
            (should (equal (car captured) "printf edited-command"))))))))

(ert-deftest python-run-file-quotes-paths-and-uses-selected-python ()
  (python-test--with-directory
    (let* ((environment (python-test--environment (expand-file-name "env $x;' quoted" directory)))
           (file (expand-file-name "calculation ' quoted; $(touch injected).py" directory))
           (display-buffer-alist '((".*" (display-buffer-no-window))))
           output)
      (write-region "print('safe-python-run')\n" nil file nil 'silent)
      (unwind-protect
          (with-temp-buffer
            (setq buffer-file-name file)
            (insert-file-contents file)
            (set-buffer-modified-p nil)
            (setq-local praharsh-python-environment environment)
            (setq output (praharsh-python-run-file))
            (should (bufferp output))
            (python-test--wait (get-buffer-process output))
            (with-current-buffer output
              (should (string-match-p "^safe-python-run$" (buffer-string))))
            (should-not (file-exists-p (expand-file-name "injected" directory))))
        (when (buffer-live-p output) (kill-buffer output))))))

(ert-deftest python-async-runs-keep-existing-processes-alive ()
  (python-test--with-directory
    (let ((display-buffer-alist '((".*" (display-buffer-no-window))))
          first second first-process second-process)
      (unwind-protect
          (with-temp-buffer
            (setq-local process-environment (copy-sequence process-environment))
            (setenv "PYTHON_TEST_VALUE" "buffer-local")
            (setq first (praharsh-python--compile "sleep 1; printf '%s' \"$PYTHON_TEST_VALUE\"" "Run"))
            (setq first-process (get-buffer-process first))
            (should (process-live-p first-process))
            (setq second (praharsh-python--compile "printf second-run" "Run"))
            (setq second-process (get-buffer-process second))
            (should-not (eq first second))
            (should (process-live-p first-process))
            (python-test--wait first-process)
            (python-test--wait second-process)
            (with-current-buffer first
              (should (string-match-p "buffer-local" (buffer-string)))))
        (dolist (buffer (list first second))
          (when (buffer-live-p buffer)
            (when-let ((process (get-buffer-process buffer))) (delete-process process))
            (kill-buffer buffer)))))))


(ert-deftest python-preserves-scientific-process-settings ()
  (python-test--with-directory
    (with-temp-buffer
      (setq-local process-environment (copy-sequence process-environment))
      (setenv "OMP_NUM_THREADS" "2")
      (setenv "PYTHONPATH" "/tmp/scientific-modules")
      (setq-local praharsh-python-environment
                  (python-test--environment (expand-file-name "science" directory)))
      (praharsh-python-setup-environment)
      (should (equal (getenv "OMP_NUM_THREADS") "2"))
      (should (equal (getenv "PYTHONPATH") "/tmp/scientific-modules"))
      (setenv "OMP_NUM_THREADS" "4")
      (praharsh-python-setup-environment)
      (should (equal (getenv "OMP_NUM_THREADS") "4")))))

(ert-deftest python-keeps-one-completion-frontend-after-org-loads ()
  (require 'auto-complete-config)
  (unwind-protect
      (progn
        (ac-config-default)
        (with-temp-buffer
          (python-mode)
          (should-not auto-complete-mode)))
    (global-auto-complete-mode -1)))

(ert-deftest python-lsp-root-matches-nested-environment-root ()
  (require 'lsp-mode)
  (python-test--with-directory
    (let ((lsp--session (make-lsp-session :folders (list directory)))
          (lsp-session-file nil)
          (lsp-auto-guess-root nil))
      (dolist (name '("package-a" "package-b"))
        (let* ((root (expand-file-name name directory))
               (environment (python-test--environment (expand-file-name ".venv" root))))
          (write-region "" nil (expand-file-name "pyproject.toml" root) nil 'silent)
          (with-temp-buffer
            (setq default-directory (file-name-as-directory root)
                  buffer-file-name (expand-file-name "model.py" root))
            (cl-letf (((symbol-function 'lsp-deferred) #'ignore))
              (praharsh-python-start))
            (should (equal praharsh-python-executable (expand-file-name "bin/python" environment)))
            (should (equal (lsp--calculate-root (lsp-session) buffer-file-name)
                           (lsp-f-canonical root)))))))))


(ert-deftest python-native-repl-completes-in-selected-environment ()
  (python-test--with-directory
    (let (process)
      (unwind-protect
          (with-temp-buffer
            (setq-local praharsh-python-environment
                        (python-test--environment (expand-file-name "repl env" directory)))
            (praharsh-python-setup-environment)
            (run-python nil nil nil)
            (setq process (python-shell-get-process))
            (should (process-live-p process))
            (let ((deadline (+ (float-time) 10)))
              (while (and (< (float-time) deadline)
                          (not (buffer-local-value 'python-shell--first-prompt-received
                                                   (process-buffer process))))
                (accept-process-output process 0.05)))
            (should (buffer-local-value 'python-shell--first-prompt-received
                                        (process-buffer process)))
            (should (equal "6" (python-shell-send-string-no-output "print(2 * 3)" process)))
            (should (member "print" (python-shell-completion-native-get-completions process "pri"))))
        (when process
          (let ((buffer (process-buffer process)))
            (delete-process process)
            (when (buffer-live-p buffer) (kill-buffer buffer))))))))


(ert-deftest python-environment-picker-discovers-and-deduplicates ()
  (python-test--with-directory
    (let* ((conda (python-test--environment (expand-file-name "conda/science" directory)))
           (project (expand-file-name "project" directory))
           (project-env (python-test--environment (expand-file-name ".venv" project)))
           (store (expand-file-name "venvs" directory))
           (venv (python-test--environment (expand-file-name "simulation" store)))
           (active (python-test--environment (expand-file-name "active" directory)))
           (remembered (python-test--environment (expand-file-name "remembered" directory)))
           (praharsh-python-venv-directories (list store))
           (praharsh-python-environment-history (list remembered (file-name-as-directory venv)))
           (process-environment (copy-sequence process-environment)))
      (make-symbolic-link venv (expand-file-name "alias" store))
      (setenv "VIRTUAL_ENV" active)
      (setenv "CONDA_PREFIX" nil)
      (setenv "WORKON_HOME" store)
      (cl-letf (((symbol-function 'praharsh-python-project-root) (lambda () project))
                ((symbol-function 'project-known-project-roots) (lambda () (list project)))
                ((symbol-function 'executable-find) (lambda (name &rest _) (and (equal name "conda") "/fake/conda")))
                ((symbol-function 'call-process)
                 (lambda (program _in _dest _display &rest args)
                   (should (equal program "/fake/conda"))
                   (should (equal args '("env" "list" "--json")))
                   (insert (json-encode `((envs . [,conda ,project-env "/missing/environment"]))))
                   0)))
        (let ((paths (mapcar #'cdr (praharsh-python-environments))))
          (should (= 5 (length paths)))
          (dolist (env (list conda project-env venv active remembered))
            (should (= 1 (cl-count (file-truename env) paths :test #'equal)))))))))

(ert-deftest python-environment-picker-survives-conda-errors ()
  (python-test--with-directory
    (let* ((venv (python-test--environment (expand-file-name ".venv" directory)))
           (praharsh-python-venv-directories nil)
           (praharsh-python-environment-history nil))
      (cl-letf (((symbol-function 'praharsh-python-project-root) (lambda () directory))
                ((symbol-function 'project-known-project-roots) (lambda () nil))
                ((symbol-function 'executable-find) (lambda (&rest _) "/fake/conda")))
        (dolist (reply '(1 "broken json"))
          (cl-letf (((symbol-function 'call-process)
                     (lambda (&rest _)
                       (if (stringp reply) (progn (insert reply) 0) reply))))
            (should (member (file-truename venv) (mapcar #'cdr (praharsh-python-environments)))))))
      (cl-letf (((symbol-function 'executable-find) (lambda (&rest _) nil))
                ((symbol-function 'praharsh-python-project-root) (lambda () directory)))
        (should (member (file-truename venv) (mapcar #'cdr (praharsh-python-environments))))))))

(ert-deftest python-environment-picker-selects-lists-and-keeps-browse-option ()
  (python-test--with-directory
    (let* ((environment (python-test--environment (expand-file-name "manual env" directory)))
           (praharsh-python-environment-history nil))
      (with-temp-buffer
        (cl-letf (((symbol-function 'praharsh-python-environments)
                   (lambda () (list (cons "science [conda]" environment))))
                  ((symbol-function 'completing-read)
                   (lambda (_prompt candidates &rest _)
                     (should (assoc "science [conda]" candidates))
                     "science [conda]")))
          (call-interactively #'praharsh-python-select-environment)
          (should (equal praharsh-python-environment environment))
          (should (member environment praharsh-python-environment-history)))
        (cl-letf (((symbol-function 'completing-read) (lambda (&rest _) "Browse for another environment..."))
                  ((symbol-function 'read-directory-name) (lambda (&rest _) environment)))
          (should (equal environment (praharsh-python-read-environment))))
        (let ((current-prefix-arg '(4)))
          (cl-letf (((symbol-function 'praharsh-python-read-environment)
                     (lambda () (ert-fail "Prefix reset must not query environments"))))
            (call-interactively #'praharsh-python-select-environment)
            (should-not praharsh-python-environment)))))))


(ert-deftest python-environment-picker-works-without-conda-on-gui-path ()
  (python-test--with-directory
    (let* ((environment (python-test--environment (expand-file-name "conda env" directory)))
           (registry (expand-file-name "environments.txt" directory))
           (praharsh-python-conda-registry-file registry)
           (process-environment (copy-sequence process-environment))
           (praharsh-python-venv-directories nil)
           (praharsh-python-environment-history nil))
      (setenv "CONDA_EXE" nil)
      (write-region (concat environment "\n/missing/stale-env\n") nil registry nil 'silent)
      (cl-letf (((symbol-function 'executable-find) (lambda (&rest _) nil))
                ((symbol-function 'praharsh-python-project-root) (lambda () directory))
                ((symbol-function 'project-known-project-roots) (lambda () nil))
                ((symbol-function 'call-process)
                 (lambda (&rest _) (ert-fail "GUI fallback must not need Conda on PATH"))))
        (let ((paths (mapcar #'cdr (praharsh-python-environments))))
          (should (member environment paths))
          (should-not (member "/missing/stale-env" paths)))))))

;;; python-test.el ends here
