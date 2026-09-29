;;; package-menu-test.el --- Package menu regression check -*- lexical-binding: t -*-

;; Run: emacs --batch -Q -l test/package-menu-test.el -f ert-run-tests-batch-and-exit
(require 'ert)
(require 'package)
(package-initialize)
(require 'use-package)
(add-to-list 'load-path (expand-file-name "config" user-emacs-directory))
(require 'init-tools)
(require 'paradox)

(ert-deftest package-menu-commands-do-not-recurse ()
  (let ((paradox-github-token t)
        (max-lisp-eval-depth 200))
    (save-window-excursion
      (dolist (command '(package-list-packages list-packages paradox-list-packages))
        ;; Use cached data through the same command dispatcher as Helm M-x.
        (let ((prefix-arg '(4)))
          (command-execute command))
        (should (eq major-mode 'paradox-menu-mode))
        (should tabulated-list-entries)))))

;;; package-menu-test.el ends here
