;;; init-lsp.el --- LSP configuration -*- lexical-binding: t -*-

;;; Commentary:
;; Language Server Protocol configuration for various languages.

;;; Code:

;; LSP keymap prefix
(setq lsp-keymap-prefix "C-c l")

;; LSP mode
(use-package lsp-mode
  :hook (((c-mode c++-mode python-mode julia-mode) . lsp)
         (lsp-mode . yas-minor-mode))
  :custom-face
  (lsp-modeline-code-actions-face ((t (:inherit mode-line))))
  :custom
  (lsp-enable-links nil)
  (lsp-keymap-prefix "C-c l")
  (lsp-enable-indentation nil)
  (lsp-enable-symbol-highlighting nil)
  :bind (:map lsp-mode-map
              ("C-c d" . lsp-describe-thing-at-point))
  :config)

;; LSP Grammarly for text modes
(use-package lsp-grammarly
  :ensure t
  :hook (text-mode . (lambda ()
                       (require 'lsp-grammarly)
                       (lsp))))

;; LSP UI
(use-package lsp-ui
  :commands lsp-ui-mode
  :bind (:map lsp-ui-mode-map
              ([remap xref-find-definitions] . lsp-ui-peek-find-definitions)
              ([remap xref-find-references] . lsp-ui-peek-find-references)
              ("C-c u" . lsp-ui-imenu)
              ("C-c C-d" . lsp-ui-doc-show))
  :init
  (setq lsp-ui-doc-use-webkit nil)
  (setq lsp-ui-peek-always-show t)
  (setq lsp-ui-sideline-show-hover t)
  (setq lsp-ui-sideline-update-mode 'line))

;; Change the font for LSP UI doc
(add-hook 'lsp-ui-doc-frame-hook
          (lambda (frame _w)
            (set-face-attribute 'default frame :font "SF Pro Text" :height 130)))

;; Change what enter does in lsp ui peek mode
(add-hook 'lsp-ui-peek-mode-hook
          (lambda()
            (local-unset-key (kbd "<return>"))
            (define-key lsp-ui-peek-mode-map (kbd "<S-return>") 'lsp-ui-peek--goto-xref)))

;; Helm LSP
(use-package helm-lsp
  :commands helm-lsp-workspace-symbol
  :bind (:map lsp-mode-map
              ("C-c f" . helm-lsp-workspace-symbol)))

;; Company LSP
(use-package company-lsp)
(setq company-backends
      '((company-files
         company-keywords
         company-capf
         company-yasnippet
         company-abbrev
         company-dabbrev)))

;; DAP mode for debugging
(require 'dap-python)
(require 'dap-cpptools)

(provide 'init-lsp)
;;; init-lsp.el ends here
