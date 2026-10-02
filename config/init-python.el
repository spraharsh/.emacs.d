;;; init-python.el --- Scientific Python tools -*- lexical-binding: t -*-

;;; Commentary:
;; One interpreter per buffer/project; long jobs use compilation, not the REPL.

;;; Code:

;; The installed third-party python-mode shadows this in its autoloads.
(require 'python)
(require 'project)
(require 'seq)

(defvar-local praharsh-python-environment nil
  "Explicit virtualenv or Conda directory; may be set in .dir-locals.el.
Nil selects the project's .venv/venv, an inherited environment, then PATH.")

(defvar-local praharsh-python-executable nil
  "Absolute interpreter selected for this buffer.")

(defvar-local praharsh-python--base-exec-path nil
  "Executable search path before this buffer selected a Python environment.")
(defvar-local praharsh-python--base-environment nil
  "Process environment before this buffer selected a Python environment.")

(defconst praharsh-python-tools-directory
  (expand-file-name ".cache/python-tools/bin/" user-emacs-directory)
  "Isolated editor tools; see README.org for installation commands.")

(defun praharsh-python-project-root ()
  "Return the nearest Python project root, or the current directory."
  (or (locate-dominating-file default-directory "pyproject.toml")
      (when-let* ((project (project-current nil))) (project-root project))
      default-directory))

(defun praharsh-python-setup-environment ()
  "Select Python locally, without changing other buffers or global PATH."
  (when (file-remote-p default-directory)
    (user-error "Select and run remote Python tools on the remote host"))
  (unless praharsh-python--base-exec-path
    (setq-local praharsh-python--base-exec-path (copy-sequence exec-path)
                praharsh-python--base-environment (copy-sequence process-environment)))
  (let* ((root (praharsh-python-project-root))
         (base-env praharsh-python--base-environment)
         (environment
          (or (and praharsh-python-environment
                   (expand-file-name praharsh-python-environment root))
              (let ((process-environment base-env))
                (seq-find
                 (lambda (dir)
                   (and dir (file-executable-p (expand-file-name "bin/python" dir))))
                 (list (expand-file-name ".venv" root)
                       (expand-file-name "venv" root)
                       (getenv "VIRTUAL_ENV") (getenv "CONDA_PREFIX"))))))
         (python (if environment
                     (expand-file-name "bin/python" environment)
                   (let ((exec-path praharsh-python--base-exec-path))
                     (or (executable-find "python3") (executable-find "python"))))))
    (unless (and python (file-executable-p python))
      (user-error "No Python executable in %s" (or environment "PATH")))
    (setq-local praharsh-python-executable python
                python-shell-interpreter python
                python-shell-interpreter-args "-i"
                python-shell-virtualenv-root environment
                python-shell-buffer-name (format "Python:%s:%s" root python)
                lsp-pyright-python-executable-cmd python
                dap-python-executable python)
    ;; Preserve scientific settings (OMP_NUM_THREADS, PYTHONPATH, CUDA, etc.),
    ;; including edits since setup; reset only variables managed by activation.
    (setq-local process-environment (copy-sequence process-environment))
    (dolist (variable '("PATH" "PYTHONHOME" "VIRTUAL_ENV" "CONDA_PREFIX"))
      (setenv variable (let ((process-environment base-env)) (getenv variable))))
    (let ((bin (file-name-directory python)))
      (setq-local exec-path (cons bin (copy-sequence praharsh-python--base-exec-path)))
      (setenv "PATH" (concat bin path-separator (or (getenv "PATH") ""))))
    (when environment
      (setenv "PYTHONHOME" nil)
      (if (file-directory-p (expand-file-name "conda-meta" environment))
          (progn (setenv "CONDA_PREFIX" environment) (setenv "VIRTUAL_ENV" nil))
        (setenv "VIRTUAL_ENV" environment)
        (setenv "CONDA_PREFIX" nil)))))

;; Set these before the clients register themselves. Each project gets its own
;; server, so different scientific environments cannot share interpreter state.
(setq lsp-pyright-multi-root nil
      lsp-ruff-multi-root nil
      lsp-pyright-type-checking-mode "basic"
      lsp-pyright-disable-organize-imports t
      lsp-pyright-python-search-functions '(lsp-pyright--locate-python-python)
      dap-python-debugger 'debugpy)

(defun praharsh-python-start ()
  "Configure the file after directory-local variables, then start its servers."
  (unless (file-remote-p default-directory)
    (praharsh-python-setup-environment)
    (let ((pyright (expand-file-name "pyright-langserver" praharsh-python-tools-directory))
          (ruff (expand-file-name "ruff" praharsh-python-tools-directory)))
      (when (and buffer-file-name (file-executable-p pyright) (file-executable-p ruff))
        (require 'lsp-pyright)
        (require 'lsp-ruff)
        (lsp-dependency 'pyright (list :system pyright))
        (setq-local lsp-ruff-server-command (list ruff "server")
                    lsp-enabled-clients '(pyright ruff)
                    lsp-enable-suggest-server-download nil
                    lsp-diagnostics-provider :flycheck
                    lsp-auto-guess-root nil
                    lsp-guess-root-without-session nil)
        (lsp-workspace-folders-add (praharsh-python-project-root))
        (lsp-deferred)))))

(defun praharsh-python-mode-setup ()
  "Use one completion frontend in either built-in Python major mode."
  (setq-local company-backends '((company-capf :with company-yasnippet)))
  (when (bound-and-true-p auto-complete-mode) (auto-complete-mode -1))
  (add-hook 'hack-local-variables-hook #'praharsh-python-start nil t))

(add-hook 'python-base-mode-hook #'praharsh-python-mode-setup)

;; Org/LaTeX later enables global-auto-complete-mode; exclude Python there too.
(with-eval-after-load 'auto-complete
  (setq ac-modes (delq 'python-mode (delq 'python-ts-mode ac-modes))))


(defcustom praharsh-python-venv-directories
  '("~/.virtualenvs" "~/.venvs" "~/.local/share/virtualenvs"
    "~/.cache/pypoetry/virtualenvs")
  "Directories containing virtualenvs to include in the environment picker.
Each directory and its immediate children are checked; no recursive scan."
  :type '(repeat directory)
  :group 'python)

(defvar praharsh-python-environment-history nil
  "Successfully selected environment paths, remembered for this Emacs session.")

(defconst praharsh-python-conda-registry-file
  (expand-file-name "~/.conda/environments.txt")
  "Conda's per-user registry, readable without Conda on PATH.")

(defun praharsh-python-environments ()
  "Return (LABEL . DIRECTORY) choices for usable local Python environments."
  (when (file-remote-p default-directory)
    (user-error "Select remote Python environments on the remote host"))
  (let ((paths (append (list praharsh-python-environment
                            python-shell-virtualenv-root
                            (getenv "VIRTUAL_ENV") (getenv "CONDA_PREFIX"))
                       praharsh-python-environment-history))
        (conda (or (let ((hint (getenv "CONDA_EXE")))
                     (and hint (file-executable-p hint) hint))
                   (executable-find "conda")))
        conda-paths)
    (when conda
      (condition-case err
          (with-temp-buffer
            (unless (eq 0 (call-process conda nil '(t nil) nil "env" "list" "--json"))
              (error "conda env list failed"))
            (goto-char (point-min))
            (setq conda-paths (alist-get 'envs
                              (json-parse-buffer :object-type 'alist :array-type 'list))))
        (error (message "Conda listing unavailable: %s" (error-message-string err)))))
    ;; Desktop Emacs may not inherit shell initialization or Conda's PATH.
    (unless conda-paths
      (let ((registry praharsh-python-conda-registry-file))
        (when (file-readable-p registry)
          (setq conda-paths
                (with-temp-buffer
                  (insert-file-contents registry)
                  (split-string (buffer-string) "[\r\n]+" t))))))
    (setq paths (append paths conda-paths))
    (dolist (root (append (list (praharsh-python-project-root))
                          (project-known-project-roots)
                          (bound-and-true-p projectile-known-projects)))
      (when (and (stringp root) (not (file-remote-p root)))
        (dolist (name '(".venv" "venv" ".env" "env"))
          (push (expand-file-name name root) paths))))
    (dolist (directory (append (list (getenv "WORKON_HOME")
                                    (getenv "POETRY_VIRTUALENVS_PATH"))
                               praharsh-python-venv-directories))
      (when (and directory (not (file-remote-p directory))
                 (file-accessible-directory-p directory))
        (push directory paths)
        (setq paths (append (directory-files directory t directory-files-no-dot-files-regexp)
                            paths))))
    (mapcar
     (lambda (directory)
       (cons (format "%s [%s]  %s"
                     (file-name-nondirectory directory)
                     (if (file-directory-p (expand-file-name "conda-meta" directory)) "conda" "venv")
                     (abbreviate-file-name directory))
             directory))
     (sort (delete-dups
            (mapcar (lambda (directory) (directory-file-name (file-truename directory)))
                    (seq-filter (lambda (directory)
                                  (and (stringp directory)
                                       (not (file-remote-p directory))
                                       (file-executable-p (expand-file-name "bin/python" directory))))
                                paths)))
           #'string-lessp))))

(defun praharsh-python-read-environment ()
  "Pick a discovered environment, or browse to another directory."
  (let* ((browse "Browse for another environment...")
         (choices (append (praharsh-python-environments) (list (cons browse nil))))
         (choice (completing-read "Python environment: " choices nil t)))
    (if (equal choice browse)
        (read-directory-name "Python environment directory: " "~/" nil t)
      (cdr (assoc choice choices)))))

(defun praharsh-python-select-environment (directory)
  "Select DIRECTORY for this buffer. With a prefix, return to auto detection."
  (interactive (list (unless current-prefix-arg
                       (praharsh-python-read-environment))))
  (let ((previous praharsh-python-environment))
    (setq-local praharsh-python-environment directory)
    (condition-case err
        (praharsh-python-setup-environment)
      (error (setq-local praharsh-python-environment previous)
             (signal (car err) (cdr err)))))
  (when directory
    (add-to-history 'praharsh-python-environment-history
                    (directory-file-name python-shell-virtualenv-root)))
  (message "Python: %s; restart LSP/REPL if already running. Use .dir-locals.el to persist."
           praharsh-python-executable))

(defun praharsh-python--compile (command label)
  "Run COMMAND asynchronously in a fresh LABEL buffer at the project root."
  (require 'compile)
  (save-some-buffers (not compilation-ask-about-save))
  (let* ((default-directory (praharsh-python-project-root))
         (name (generate-new-buffer-name
                (format "*Python %s:%s*" label (abbreviate-file-name default-directory)))))
    (compilation-start command 'compilation-mode (lambda (_mode) name))))

(defun praharsh-python-run-file (&optional edit)
  "Run this file with unbuffered output. With EDIT, edit the shell command."
  (interactive "P")
  (unless buffer-file-name (user-error "Save this Python buffer to a file first"))
  (save-buffer)
  (praharsh-python-setup-environment)
  (let ((command (mapconcat #'shell-quote-argument
                            (list praharsh-python-executable "-u" buffer-file-name) " ")))
    (praharsh-python--compile
     (if edit (read-shell-command "Run Python: " command) command) "run")))

(defun praharsh-python-test (&optional edit)
  "Run pytest in the project environment. With EDIT, edit the shell command."
  (interactive "P")
  (praharsh-python-setup-environment)
  (let ((command (concat (shell-quote-argument praharsh-python-executable) " -m pytest")))
    (praharsh-python--compile
     (if edit (read-shell-command "Pytest: " command) command) "test")))

(defun praharsh-python-jupyter ()
  "Start JupyterLab for this project; open the URL printed in its output."
  (interactive)
  (praharsh-python-setup-environment)
  (praharsh-python--compile
   (concat (shell-quote-argument praharsh-python-executable) " -m jupyterlab --no-browser")
   "jupyter"))

(defvar praharsh-python-command-map
  (let ((map (make-sparse-keymap)))
    (dolist (binding '(("e" . praharsh-python-select-environment)
                       ("r" . praharsh-python-run-file)
                       ("t" . praharsh-python-test)
                       ("j" . praharsh-python-jupyter)
                       ("f" . lsp-format-buffer)
                       ("o" . lsp-organize-imports)
                       ("d" . dap-debug)
                       ("s" . run-python)))
      (define-key map (kbd (car binding)) (cdr binding)))
    map)
  "Scientific Python commands, under C-c v.")

(define-key python-base-mode-map (kbd "C-c v") praharsh-python-command-map)

;; Existing notebook frontends remain optional and load on explicit commands.
(use-package jupyter :commands (jupyter-run-repl jupyter-connect-repl))
(setq ein:output-area-inlined-images t)

(provide 'init-python)
;;; init-python.el ends here
