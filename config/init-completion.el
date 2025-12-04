;;; init-completion.el --- Completion frameworks -*- lexical-binding: t -*-

;;; Commentary:
;; Company, Helm, auto-complete, and which-key configuration.

;;; Code:

;; Company mode
(use-package company-mode)
(add-hook 'after-init-hook 'global-company-mode)
(setq company-idle-delay 0)
(setq company-show-numbers 'left)

;; Company box - flashy company mode
(use-package company-box
  :hook (company-mode . company-box-mode))

;; Company number selection function
(defun ora-company-number ()
  "Forward to `company-complete-number'.
Taken from https://oremacs.com/2017/12/27/company-numbers/
Unless the number is potentially part of the candidate.
In that case, insert the number."
  (interactive)
  (let* ((k (this-command-keys))
         (re (concat "^" company-prefix k)))
    (if (cl-find-if (lambda (s) (string-match re s))
                    company-candidates)
        (self-insert-command 1)
      (company-complete-number (string-to-number k)))))

;; Company keybindings
(with-eval-after-load 'company
  (define-key company-active-map (kbd "C-s") 'company-complete-common-or-cycle)
  (define-key company-active-map (kbd "C-r") 'company-select-previous-or-abort))

;; Which key
(setq which-key-show-early-on-C-h t)
(setq which-key-idle-delay 0.5)
(setq which-key-idle-secondary-delay 0.05)
(use-package which-key)
(which-key-mode)
(which-key-setup-side-window-bottom)

;; Eldoc box
(use-package eldoc-box)

;; Helm
(use-package helm-config)
(use-package helm
  :config
  (global-set-key (kbd "M-x") #'helm-M-x)
  (global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
  (global-set-key (kbd "C-x C-f") #'helm-find-files)
  (global-set-key (kbd "C-M-y") 'helm-show-kill-ring)
  (global-set-key (kbd "C-c b") 'helm-buffers-list)
  (helm-mode 1))

;; ac-helm
(with-eval-after-load 'ac-helm
  (global-set-key (kbd "C-:") 'ac-complete-with-helm)
  (define-key ac-complete-mode-map (kbd "C-:") 'ac-complete-with-helm))

;; Rainbow delimiters
(use-package rainbow-delimiters)

;; Auto-complete base setup
(use-package auto-complete)
(use-package auto-complete-config)
(ac-config-default)
(setq ac-auto-start nil)
(setq ac-auto-show-menu t)
(global-auto-complete-mode t)
(ac-flyspell-workaround)

(provide 'init-completion)
;;; init-completion.el ends here
