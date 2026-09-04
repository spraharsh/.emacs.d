;;; startup-test.el --- Startup regression check -*- lexical-binding: t -*-

(require 'ert)
(package-initialize)
(add-to-list 'load-path (expand-file-name "config" user-emacs-directory))

;; Font enumeration requires a GUI, which the startup check does not.
(when noninteractive
  (defalias 'x-list-fonts #'ignore)
  (defalias 'x-family-fonts #'ignore))

(dolist (module '(init-packages init-core init-ui init-completion init-editing
                  init-navigation init-programming init-lsp init-python
                  init-latex init-org init-git init-tools))
  (require module))

(ert-deftest startup-keeps-agenda-and-defers-optional-packages ()
  (should (featurep 'org))
  (should (memq 'org-agenda-list after-init-hook))
  (dolist (feature '(graphene all-the-icons neotree eldoc-box
                     rainbow-delimiters auto-complete auto-complete-config
                     multiple-cursors copilot vterm helm-swoop
                     lsp-mode lsp-grammarly pyvenv company-lsp
                     dap-python dap-cpptools tex helm-bibtex ac-math
                     org-journal ox-latex ob-python org-alert org-download org2jekyll
                     elfeed elfeed-goodies elfeed-org dired-quick-sort
                     edit-server paradox))
    (should-not (featurep feature)))
  (let ((org-agenda-files '("~/Dropbox/todo.org")))
    (org-agenda-list))
  (should (get-buffer "*Org Agenda*")))

;;; startup-test.el ends here
