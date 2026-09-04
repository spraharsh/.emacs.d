;;; init-org.el --- Org mode configuration -*- lexical-binding: t -*-

;;; Commentary:
;; Org-mode, org-journal, babel, and org customization.

;;; Code:

;; Org keybindings
(global-set-key "\C-cl" 'org-store-link)
(global-set-key (kbd "<f12>") 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
;; org-iswitchb was removed in newer org-mode versions
;; C-c b now uses helm-buffers-list (set in init-completion.el)

(use-package org
  :demand t)

;; Org startup settings
(setq org-startup-indented t
      org-hide-leading-stars t)
(setq org-log-done 'time)
(setq org-log-done 'note)

;; Org journal
(use-package org-journal
  :commands org-journal-new-entry)
(setq org-agenda-window-setup 'only-window)
(global-set-key (kbd "<f10>") 'org-journal-new-entry)

;; Org themes
(setq org-fontify-whole-heading-line t)
(add-to-list 'org-modules 'org-habit t)

;; Org TODO keywords with logging
(setq org-todo-keywords
      '((sequence "TODO(t)" "WAIT(w@/!)" "|" "DONE(d@)" "CANCELED(c@)")))

;; Org clock persistence
(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)
(setq org-clock-mode-line-total 'current)

;; Org LaTeX highlighting
(setq org-highlight-latex-and-related '(latex script entities))

;; Org archive function
(defvar org-my-archive-expiry-days 2
  "The number of days after which a completed task should be auto-archived.
This can be 0 for immediate, or a floating point value.")

(defun org-my-archive-done-tasks ()
  "Archive tasks that are done and older than `org-my-archive-expiry-days'."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (let ((done-regexp
           (concat "\\* \\(" (regexp-opt org-done-keywords) "\\) "))
          (state-regexp
           (concat "- State \"\\(" (regexp-opt org-done-keywords)
                   "\\)\"\\s-*\\[\\([^]\n]+\\)\\]")))
      (while (re-search-forward done-regexp nil t)
        (let ((end (save-excursion
                     (outline-next-heading)
                     (point)))
              begin)
          (goto-char (line-beginning-position))
          (setq begin (point))
          (when (re-search-forward state-regexp end t)
            (let* ((time-string (match-string 2))
                   (when-closed (org-parse-time-string time-string)))
              (if (>= (time-to-number-of-days
                       (time-subtract (current-time)
                                      (apply #'encode-time when-closed)))
                      org-my-archive-expiry-days)
                  (org-archive-subtree)))))))))

(defalias 'archive-done-tasks 'org-my-archive-done-tasks)

;; Org capture templates
(setq org-default-notes-file (concat org-directory "/todo.org"))
(setq org-capture-templates
      '(("t" "todo" entry (file+headline "~/Dropbox/todo.org" "Tasks")
         "* TODO [#A] %?\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+0d\"))\n%a\n")
        ("r" "Paper to Read" entry (file+headline "~/Dropbox/todo.org" "Research Reading")
         "* TOREAD [#C] %?\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+0d\"))\n%a\n")))

(defun bjm/org-capture-todo ()
  "Capture a TODO item."
  (interactive)
  (org-capture nil "t"))

(define-key global-map (kbd "C-c t") 'bjm/org-capture-todo)

;; Org babel
(use-package ox-latex
  :defer t)
(setq org-latex-create-formula-image-program 'dvipng)
;; ponytail: idle-load Babel backends; use per-language dispatch if the pause
;; becomes noticeable.
(run-with-idle-timer
 1 nil
 (lambda ()
   (org-babel-do-load-languages
    'org-babel-load-languages
    '((latex . t) (python . t) (haskell . t) (emacs-lisp . t)))))

;; Show agenda on startup
(add-hook 'after-init-hook 'org-agenda-list)

;; Org alert
(use-package org-alert
  :defer t)

;; Org download
(use-package org-download
  :commands org-download-enable
  :hook (dired-mode . org-download-enable))

;; Org2jekyll
(use-package org2jekyll
  :defer t)

;; Org bullets
(setq org-hide-emphasis-markers t)
(font-lock-add-keywords 'org-mode
                        '(("^ *\\([-]\\) "
                           (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))
(use-package org-bullets
  :hook (org-mode . org-bullets-mode))

;; Org mode variable pitch
(add-hook 'org-mode-hook 'variable-pitch-mode)

;; Org face customizations
(let* ((variable-tuple
        (cond ((x-list-fonts "SF Pro Display")         '(:font "SF Pro Display"))
              ((x-family-fonts "Sans Serif")    '(:family "Sans Serif"))
              (nil (warn "Cannot find a Sans Serif Font.  Install Source Sans Pro."))))
       (base-font-color     (face-foreground 'default nil 'default))
       (headline           `(:inherit default :weight bold :foreground ,base-font-color)))
  (custom-theme-set-faces
   'user
   `(org-level-8 ((t (,@headline ,@variable-tuple))))
   `(org-level-7 ((t (,@headline ,@variable-tuple))))
   `(org-level-6 ((t (,@headline ,@variable-tuple))))
   `(org-level-5 ((t (,@headline ,@variable-tuple))))
   `(org-level-4 ((t (,@headline ,@variable-tuple :height 1.1))))
   `(org-level-3 ((t (,@headline ,@variable-tuple :height 1.25))))
   `(org-level-2 ((t (,@headline ,@variable-tuple :height 1.5))))
   `(org-level-1 ((t (,@headline ,@variable-tuple :height 1.75))))
   `(org-document-title ((t (,@headline ,@variable-tuple :height 2.0 :underline nil))))))

(custom-theme-set-faces
 'user
 '(org-block ((t (:inherit fixed-pitch))))
 '(org-code ((t (:inherit (shadow fixed-pitch)))))
 '(org-document-info ((t (:foreground "dark orange"))))
 '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
 '(org-indent ((t (:inherit (org-hide fixed-pitch)))))
 '(org-link ((t (:foreground "royal blue" :underline t))))
 '(org-meta-line ((t (:inherit (font-lock-comment-face fixed-pitch)))))
 '(org-property-value ((t (:inherit fixed-pitch))) t)
 '(org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch)))))
 '(org-table ((t (:inherit fixed-pitch :foreground "#83a598"))))
 '(org-tag ((t (:inherit (shadow fixed-pitch) :weight bold :height 0.8))))
 '(org-verbatim ((t (:inherit (shadow fixed-pitch)))))
 '(org-default ((t (:weight demibold)))))

(provide 'init-org)
;;; init-org.el ends here
