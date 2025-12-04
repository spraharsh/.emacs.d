;;; init-latex.el --- LaTeX configuration -*- lexical-binding: t -*-

;;; Commentary:
;; AUCTeX, reftex, helm-bibtex, and LaTeX tooling.

;;; Code:

;; Preview
(use-package preview
  :commands LaTeX-preview-setup
  :init
  (setq-default preview-scale 2.0
                preview-scale-function '(lambda () (* (/ 10.0 (preview-document-pt)) preview-scale))))

;; AUCTeX
(use-package tex
  :ensure auctex
  :config
  (setq TeX-master nil)
  (setq TeX-command-default "LatexMk"
        TeX-save-query nil
        TeX-show-compilation t
        TeX-command-BibTeX "Biber")
  (add-to-list 'TeX-command-list
               '("LatexMk" "latexmk -pdf -interaction=nonstopmode %s"
                 TeX-run-TeX nil t :help "Run latexmk"))
  (add-to-list 'TeX-command-list
               '("LatexMk-PVC" "latexmk -pdf -pvc -interaction=nonstopmode %s"
                 TeX-run-TeX nil t :help "Run latexmk with preview continuous"))
  (add-hook 'LaTeX-mode-hook
            (lambda ()
              (local-set-key (kbd "C-c C-l")
                             (lambda () (interactive)
                               (TeX-command "LatexMk-PVC" 'TeX-master-file))))))

;; Company math symbols
(add-to-list 'company-backends 'company-math-symbols-unicode)

(defun latex-company ()
  "Set up LaTeX company backends."
  (setq-local company-backends
              (append '((company-math-symbols-latex company-latex-commands))
                      company-backends)))

(defun add-my-latex-environments ()
  "Add custom LaTeX environments."
  (LaTeX-add-environments
   '("empheq" LaTeX-env-label)))

;; LaTeX mode company backends
(add-hook 'LaTeX-mode-hook
          (lambda ()
            (set (make-local-variable 'company-backends)
                 '((company-reftex
                    company-auctex
                    company-yasnippet
                    company-math-symbols-latex
                    company-dabbrev)))))

;; Reftex settings
(setq reftex-label-alist
      '(("empheq" ?e nil nil t)))

;; LaTeX labels and settings
(setq LaTeX-eqnarray-label "eq"
      LaTeX-equation-label "eq"
      LaTeX-figure-label "fig"
      LaTeX-table-label "tab"
      LaTeX-myChapter-label "chap"
      TeX-auto-save t
      TeX-newline-function 'reindent-then-newline-and-indent
      TeX-parse-self t
      TeX-style-path
      '("style/" "auto/"
        "/usr/share/emacs21/site-lisp/auctex/style/"
        "/var/lib/auctex/emacs21/"
        "/usr/local/share/emacs/site-lisp/auctex/style/")
      LaTeX-section-hook
      '(LaTeX-section-heading
        LaTeX-section-title
        LaTeX-section-toc
        LaTeX-section-section
        LaTeX-section-label))
(setq latex-run-command "xelatex")

;; Reftex and math mode hooks
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)

;; Langtool keybindings
(global-set-key "\C-x4w" 'langtool-check)
(global-set-key "\C-x4W" 'langtool-check-done)
(global-set-key "\C-x4l" 'langtool-switch-default-language)
(global-set-key "\C-x44" 'langtool-show-message-at-point)
(global-set-key "\C-x4c" 'langtool-correct-buffer)
(global-set-key (kbd "<kp-6>") 'langtool-goto-next-error)
(global-set-key (kbd "<kp-4>") 'langtool-goto-previous-error)

;; Helm bibtex
(use-package helm-bibtex
  :config
  (setq bibtex-completion-bibliography '("~/Dropbox/thesis/thesis.bib")
        bibtex-completion-pdf-field "file"
        bibtex-dialect 'biblatex
        bibtex-completion-display-formats
        '((article       . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${journal:40}")
          (inbook        . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} Chapter ${chapter:32}")
          (incollection  . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
          (inproceedings . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
          (t             . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*}"))))

(setq bibtex-completion-cite-default-as-initial-input t)

;; Set insert citation as the default action
(helm-bibtex-helmify-action bibtex-completion-insert-citation helm-bibtex-insert-citation)
(global-set-key (kbd "C-c h") 'helm-bibtex)

(helm-delete-action-from-source "Insert Citation" helm-source-bibtex)
(helm-add-action-to-source "Insert Citation"
                           'helm-bibtex-insert-citation
                           helm-source-bibtex 0)

;; Open citation on Google Scholar
(defun bibtex-completion-open-google-scholar (keys)
  "Open Google Scholar search for the selected entries KEYS."
  (dolist (key keys)
    (let* ((entry (bibtex-completion-get-entry key))
           (title (bibtex-completion-get-value "title" entry))
           (author (bibtex-completion-get-value "author" entry))
           (query (url-hexify-string (concat title " " author))))
      (browse-url (concat "https://scholar.google.com/scholar?q=" query)))))

(helm-bibtex-helmify-action bibtex-completion-open-google-scholar helm-bibtex-open-google-scholar)
(helm-add-action-to-source "Open on Google Scholar"
                           'helm-bibtex-open-google-scholar
                           helm-source-bibtex 1)

;; Auto-complete for LaTeX
(add-to-list 'ac-modes 'latex-mode)
(use-package ac-math)
(defun my-ac-latex-mode ()
  "Add ac-sources for latex."
  (setq ac-sources
        (append '(ac-source-math-unicode
                  ac-source-math-latex
                  ac-source-latex-commands)
                ac-sources)))
(add-hook 'LaTeX-mode-hook 'my-ac-latex-mode)
(setq ac-math-unicode-in-math-p t)

(provide 'init-latex)
;;; init-latex.el ends here
