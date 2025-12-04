;;; init-programming.el --- Programming tools -*- lexical-binding: t -*-

;;; Commentary:
;; General programming mode configuration and tools.

;;; Code:

;; Tree-sitter
(use-package tree-sitter)
(use-package tree-sitter-langs)
(global-tree-sitter-mode)
(add-hook 'tree-sitter-mode-hook #'tree-sitter-hl-mode)

;; Smartparens
(use-package smartparens-mode
  :ensure smartparens
  :hook (prog-mode text-mode markdown-mode)
  :config
  (require 'smartparens-config))

;; Flycheck
(global-flycheck-mode)
'(flycheck-check-syntax-automatically (quote (save idle-change mode-enabled)))

;; Highlight indent guides
(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)

;; C/C++ settings
(c-set-offset 'innamespace 0)

;; Haskell mode
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)

;; VTerm
(use-package vterm
  :load-path "/home/praharsh/emacs-libvterm")

(provide 'init-programming)
;;; init-programming.el ends here
