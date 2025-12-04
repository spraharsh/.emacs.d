;;; init-packages.el --- Package management and load paths -*- lexical-binding: t -*-

;;; Commentary:
;; Package archives, load paths, and bootstrap configuration.

;;; Code:

;; Package archives
(require 'package)
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; Load paths
(add-to-list 'load-path "~/.emacs.d/plugins")
(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/rtags")
(add-to-list 'load-path "~/.emacs.d/plugins/alltheicons")
(add-to-list 'load-path "/home/praharsh/.emacs.d/plugins/copilot.el")

;; Path to julia
(add-to-list 'exec-path "/home/praharsh/julia-1.6.1/bin")

;; Graphene - early load needed
(use-package graphene)

(provide 'init-packages)
;;; init-packages.el ends here
