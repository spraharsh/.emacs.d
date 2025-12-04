;;; init-core.el --- Core Emacs settings -*- lexical-binding: t -*-

;;; Commentary:
;; Basic Emacs configuration: performance, startup, and general behavior.

;;; Code:

;; Confirm before exiting
(setq confirm-kill-emacs 'y-or-n-p)

;; Electric indent
(define-key prog-mode-map (kbd "<return>") 'default-indent-new-line)
(electric-indent-mode 1)

;; Global autorevert - updates buffers when files change on disk
(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)
(setq auto-revert-verbose nil)

;; Garbage collection settings
(setq gc-cons-threshold 100000000)
(add-hook 'after-init-hook (lambda () (setq gc-cons-threshold 100000000)))

;; Process output speed
(setq read-process-output-max (* 1024 1024))

;; Disable final newline requirement
(setq-default mode-require-final-newline nil)

;; Disable startup screen
(setq inhibit-startup-screen t)

;; Suppress byte-compile warnings
(setq byte-compile-warnings '(not free-vars))

;; Frame title for arbtt tracking
(setq frame-title-format "%f")

;; User info
(setq user-full-name "Praharsh Suryadevara")
(setq user-mail-address "praharsharmm@gmail.com")

;; Misc settings
(put 'set-goal-column 'disabled nil)

;; Cluster PBS commands
(setq auto-mode-interpreter-regexp
      "#\\(?:!\\|PBS -S \\)[ \t]?\\([^ \t\n]*/bin/env[ \t]\\)?\\([^ \t\n]+\\)")

;; Add /usr/bin to exec-path for external programs
(setq exec-path (append exec-path '("/usr/bin")))

(provide 'init-core)
;;; init-core.el ends here
