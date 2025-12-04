;;; init-editing.el --- Editing tools -*- lexical-binding: t -*-

;;; Commentary:
;; Multiple cursors, undo-tree, yasnippet, copilot, and editing utilities.

;;; Code:

;; Insert file name function
(defun insert-file-name (filename &optional args)
  "Insert name of file FILENAME into buffer after point.

Prefixed with \\[universal-argument], expand the file name to
its fully canocalized path.  See `expand-file-name'.

Prefixed with \\[negative-argument], use relative path to file
name from current directory, `default-directory'.  See
`file-relative-name'.

The default with no prefix is to insert the file name exactly as
it appears in the minibuffer prompt.

ARGS controls the behavior as described above."
  (interactive "*fInsert file name: \nP")
  (cond ((eq '- args)
         (insert (file-relative-name filename)))
        ((not (null args))
         (insert (expand-file-name filename)))
        (t
         (insert filename))))

(global-set-key "\C-c\C-i" 'insert-file-name)
(global-set-key (kbd "C-c g") 'google-this)

;; Multiple cursors
(use-package multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; Undo tree
(use-package undo-tree)
(global-undo-tree-mode 1)

;; Yasnippet
(use-package yasnippet)
(yas-global-mode 1)
(define-key yas-minor-mode-map (kbd "<C-tab>") 'yas-expand)
(define-key yas-keymap [tab] 'yas-next-field-or-maybe-expand)
(setq yas-snippet-dirs (append yas-snippet-dirs
                               '("~/.emacs.d/snippets")))

;; Copilot
(require 'copilot)
(add-hook 'prog-mode-hook 'copilot-mode)
(define-key copilot-completion-map (kbd "<tab>") 'copilot-accept-completion)
(define-key copilot-completion-map (kbd "TAB") 'copilot-accept-completion)

;; Macro keybindings
(global-set-key (kbd "<f5>") 'kmacro-cycle-ring-previous)
(global-set-key (kbd "<f6>") 'kmacro-cycle-ring-next)

;; Open and goto new buffer macro
(fset 'open-and-goto-new-buffer
      (kmacro-lambda-form [?\C-x ?3 ?\C-x ?o] 0 "%d"))

(provide 'init-editing)
;;; init-editing.el ends here
