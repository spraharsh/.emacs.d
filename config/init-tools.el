;;; init-tools.el --- Miscellaneous tools -*- lexical-binding: t -*-

;;; Commentary:
;; Elfeed, dired, edit-server, paradox, and other tools.

;;; Code:

;; Elfeed RSS
(require 'elfeed)
(require 'elfeed-goodies)
(elfeed-goodies/setup)
(require 'elfeed-org)
(elfeed-org)
(setq rmh-elfeed-org-files (list "~/.emacs.d/elfeed.org"))

(defun elfeed-mark-all-as-read ()
  "Mark all elfeed entries as read."
  (interactive)
  (mark-whole-buffer)
  (elfeed-search-untag-all-unread))

(define-key elfeed-search-mode-map (kbd "R") 'elfeed-mark-all-as-read)
(global-set-key (kbd "C-x w") (lambda () (interactive) (elfeed) (elfeed-update)))

;; Emojify
(add-hook 'after-init-hook #'global-emojify-mode)

;; Dired quick sort
(use-package dired-quick-sort
  :ensure t
  :config
  (dired-quick-sort-setup))

;; Edit server (for browser integration)
(require 'edit-server)
(edit-server-start)

;; Paradox (package manager)
(use-package paradox)
(paradox-enable)

;; Anzu (search indicator)
(use-package anzu)
(global-anzu-mode +1)

;; Run terminal function
(defun run-terminal ()
  "Launch application in a terminal emulator."
  (interactive)
  (start-process
   "termx"
   nil
   "gnome-terminal" "-e" (read-shell-command "Shell: ")))

(provide 'init-tools)
;;; init-tools.el ends here
