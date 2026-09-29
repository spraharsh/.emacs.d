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

;;; Appearance ---------------------------------------------------------------

;; Markup: hide *bold* markers, render \alpha as α, only x^{2} as superscript,
;; hide the #+title keyword (the title text stays), show images inline.
(setq org-hide-emphasis-markers t
      org-pretty-entities t
      org-use-sub-superscripts '{}
      org-hidden-keywords '(title)
      org-ellipsis "…"
      org-startup-with-inline-images t
      org-image-actual-width '(600))

;; Tags can't right-align in a proportional font, so keep them next to the heading.
(setq org-tags-column 0
      org-auto-align-tags nil
      org-agenda-tags-column 0)

;; Agenda: thin separators, dotted time grid, "now" marker; monospace so columns line up.
(setq org-agenda-block-separator ?─
      org-agenda-time-grid '((daily today require-timed)
                             (800 1000 1200 1400 1600 1800 2000)
                             " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
      org-agenda-current-time-string "◀── now ─────────────────────────────────────────────────")
(add-hook 'org-agenda-mode-hook #'praharsh-prog-fonts)

;; org-modern: fold-state triangles for stars, pill labels for TODO/tags/dates,
;; real table borders, • bullets, ☐/☑ checkboxes.
(use-package org-modern
  :ensure t
  :hook ((org-mode . org-modern-mode)
         (org-agenda-finalize . org-modern-agenda))
  :custom
  ;; Only glyphs DejaVu Sans has, so every level renders in the same font.
  (org-modern-fold-stars '(("▶" . "▼") ("▷" . "▽") ("▸" . "▾") ("▹" . "▿"))))

;; Prose layout: proportional font, soft wrap at word boundaries, a little leading.
(defun praharsh-org-prose ()
  "Typeset the current org buffer like a document."
  (variable-pitch-mode 1)
  (visual-line-mode 1)
  (setq-local line-spacing 0.15))

(add-hook 'org-mode-hook #'praharsh-org-prose)

;; Headings: display cut of the body font, one color, sized by level.
;; Change the body/code fonts in init-ui.el (variable-pitch / fixed-pitch).
(let* ((color (face-foreground 'default nil t))
       (h `(:inherit variable-pitch :family "SF Pro Display"
            :weight semibold :foreground ,color)))
  (custom-theme-set-faces
   'user
   `(org-document-title ((t (,@h :height 2.0 :underline nil))))
   `(org-level-1 ((t (,@h :height 1.75))))
   `(org-level-2 ((t (,@h :height 1.5))))
   `(org-level-3 ((t (,@h :height 1.25))))
   `(org-level-4 ((t (,@h :height 1.1))))
   `(org-level-5 ((t (,@h))))
   `(org-level-6 ((t (,@h))))
   `(org-level-7 ((t (,@h))))
   `(org-level-8 ((t (,@h))))))

;; Everything that needs columns to line up stays monospace.
(custom-theme-set-faces
 'user
 '(org-block ((t (:inherit fixed-pitch))))
 '(org-code ((t (:inherit (shadow fixed-pitch)))))
 '(org-verbatim ((t (:inherit (shadow fixed-pitch)))))
 '(org-table ((t (:inherit fixed-pitch))))
 '(org-formula ((t (:inherit fixed-pitch))))
 '(org-checkbox ((t (:inherit fixed-pitch))))
 '(org-drawer ((t (:inherit (shadow fixed-pitch)))))
 '(org-property-value ((t (:inherit fixed-pitch))))
 '(org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch)))))
 '(org-meta-line ((t (:inherit (font-lock-comment-face fixed-pitch)))))
 '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
 '(org-indent ((t (:inherit (org-hide fixed-pitch)))))
 '(org-modern-symbol ((t (:family "DejaVu Sans")))))

(provide 'init-org)
;;; init-org.el ends here
