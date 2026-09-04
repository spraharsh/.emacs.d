;;; init-tools.el --- Miscellaneous tools -*- lexical-binding: t -*-

;;; Commentary:
;; Elfeed, dired, edit-server, paradox, and other tools.

;;; Code:

;; Elfeed RSS
(defun praharsh-elfeed-update ()
  "Open Elfeed and update its feeds."
  (interactive)
  (elfeed)
  (elfeed-update))

(use-package elfeed
  :commands (elfeed elfeed-update)
  :bind ("C-x w" . praharsh-elfeed-update)
  :init
  (setq rmh-elfeed-org-files (list "~/.emacs.d/elfeed.org"))
  :config
  (require 'elfeed-goodies)
  (elfeed-goodies/setup)
  (require 'elfeed-org)
  (elfeed-org)

  (defun elfeed-mark-all-as-read ()
    "Mark all Elfeed entries as read."
    (interactive)
    (mark-whole-buffer)
    (elfeed-search-untag-all-unread))

  (define-key elfeed-search-mode-map (kbd "R") #'elfeed-mark-all-as-read))

;; Emojify
(run-with-idle-timer 1 nil #'global-emojify-mode)

;; Dired quick sort
(use-package dired-quick-sort
  :ensure t
  :hook (dired-mode . dired-quick-sort-setup))

;; Edit server (for browser integration)
(use-package edit-server
  :defer 2
  :config
  (edit-server-start))

;; Paradox (package manager)
(use-package paradox
  :commands paradox-list-packages)

(defun praharsh-paradox-list-packages (&optional no-fetch)
  "Open Paradox, optionally without refreshing package data."
  (paradox-list-packages no-fetch))

(advice-add 'list-packages :override #'praharsh-paradox-list-packages)

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
