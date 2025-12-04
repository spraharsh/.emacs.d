;;; init-python.el --- Python configuration -*- lexical-binding: t -*-

;;; Commentary:
;; Python, pyvenv, elpy, and Jupyter configuration.

;;; Code:

;; Pyvenv activation
(pyvenv-activate "/home/praharsh/anaconda3/envs/changebranch3")
(setq elpy-rpc-python-command "/home/praharsh/anaconda3/envs/changebranch3/bin/python")

;; Python mode company backends
(add-hook 'python-mode-hook
          (lambda ()
            (set (make-local-variable 'company-backends)
                 '((company-capf :with company-yasnippet)))))

;; Disable auto-complete in python mode (use company instead)
(add-hook 'python-mode-hook (lambda () (auto-complete-mode -1)))

;; Jupyter/ein config
(setq ein:output-area-inlined-images t)

;; Python shell completion fix
(with-eval-after-load 'python
  (defun python-shell-completion-native-try ()
    "Return non-nil if can trigger native completion."
    (let ((python-shell-completion-native-enable t)
          (python-shell-completion-native-output-timeout
           python-shell-completion-native-try-output-timeout))
      (python-shell-completion-native-get-completions
       (get-buffer-process (current-buffer))
       nil "_"))))

(provide 'init-python)
;;; init-python.el ends here
