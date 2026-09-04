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
  :defer t
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
  :commands helm-bibtex
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

(global-set-key (kbd "C-c h") 'helm-bibtex)

;; Open citation on Google Scholar
(defun bibtex-completion-open-google-scholar (keys)
  "Open Google Scholar search for the selected entries KEYS."
  (dolist (key keys)
    (let* ((entry (bibtex-completion-get-entry key))
           (title (bibtex-completion-get-value "title" entry))
           (author (bibtex-completion-get-value "author" entry))
           (query (url-hexify-string (concat title " " author))))
      (browse-url (concat "https://scholar.google.com/scholar?q=" query)))))

(with-eval-after-load 'helm-bibtex
  (helm-bibtex-helmify-action
   bibtex-completion-insert-citation helm-bibtex-insert-citation)
  (helm-delete-action-from-source "Insert Citation" helm-source-bibtex)
  (helm-add-action-to-source "Insert Citation"
                             'helm-bibtex-insert-citation
                             helm-source-bibtex 0)
  (helm-bibtex-helmify-action
   bibtex-completion-open-google-scholar helm-bibtex-open-google-scholar)
  (helm-add-action-to-source "Open on Google Scholar"
                             'helm-bibtex-open-google-scholar
                             helm-source-bibtex 1))

;; Google Scholar search and cite with Helm
(use-package gscholar-bibtex
  :ensure t
  :after (helm bibtex-completion)
  :config
  (setq gscholar-bibtex-default-source "Google Scholar"))

;; State variables for helm-gscholar
(defvar helm-gscholar--search-results nil
  "Store the current search results from gscholar-bibtex.")

(defvar helm-gscholar--bibtex-cache (make-hash-table :test 'equal)
  "Cache mapping result indices to their BibTeX entries.")

(defvar helm-gscholar--current-query nil
  "Store current search query.")

;; Helper: Parse BibTeX string to extract fields
(defun helm-gscholar--parse-bibtex-string (bibtex-str)
  "Parse BIBTEX-STR and return an alist with key fields."
  (when bibtex-str
    (with-temp-buffer
      (insert bibtex-str)
      (goto-char (point-min))
      (when (re-search-forward "@\\([a-zA-Z]+\\){\\([^,]+\\)," nil t)
        (let* ((entry-type (match-string 1))
               (entry-key (match-string 2))
               (fields (list (cons "=type=" entry-type)
                             (cons "=key=" entry-key)
                             (cons "=bibtex=" bibtex-str))))
          (dolist (field '("author" "title" "year" "journal" "booktitle"))
            (goto-char (point-min))
            (when (re-search-forward
                   (format "%s\\s-*=\\s-*[{\"]\\([^}\"]+\\)[}\"]" field) nil t)
              (push (cons field (match-string 1)) fields)))
          (nreverse fields))))))

;; Helper: Find local bibliography file from buffer
(defun helm-gscholar--find-local-bib-file ()
  "Find the bibliography file from current LaTeX buffer."
  (save-excursion
    (save-restriction
      (widen)
      (goto-char (point-min))
      (let ((bib-file nil)
            (buffer-dir (when buffer-file-name
                          (file-name-directory buffer-file-name))))
        ;; Try \addbibresource{file.bib} (biblatex)
        (when (re-search-forward
               "\\\\addbibresource\\(?:\\[.*?\\]\\)?{\\([^}]+\\)}" nil t)
          (setq bib-file (match-string 1)))
        ;; Try \bibliography{file} (bibtex)
        (unless bib-file
          (goto-char (point-min))
          (when (re-search-forward "\\\\bibliography{\\([^}]+\\)}" nil t)
            (setq bib-file (match-string 1))))
        ;; Expand the path
        (when bib-file
          (setq bib-file (concat (file-name-sans-extension bib-file) ".bib"))
          (cond
           ((file-name-absolute-p bib-file) bib-file)
           ((and buffer-dir (file-exists-p (expand-file-name bib-file buffer-dir)))
            (expand-file-name bib-file buffer-dir))
           ((file-exists-p (expand-file-name bib-file))
            (expand-file-name bib-file))
           (t (when buffer-dir (expand-file-name bib-file buffer-dir)))))))))

;; Helper: Check if entry with title exists in bib file
(defun helm-gscholar--entry-exists-p (title bib-file)
  "Check if entry with TITLE already exists in BIB-FILE."
  (when (and title bib-file (file-exists-p bib-file))
    (let ((normalized-title (downcase (replace-regexp-in-string
                                       "\\s-+" " "
                                       (string-trim title)))))
      (with-temp-buffer
        (insert-file-contents bib-file)
        (goto-char (point-min))
        (catch 'found
          (while (re-search-forward "title\\s-*=\\s-*[{\"]\\([^}\"]+\\)[}\"]" nil t)
            (let ((existing-title (downcase
                                   (replace-regexp-in-string
                                    "\\s-+" " "
                                    (string-trim (match-string 1))))))
              (when (string= normalized-title existing-title)
                (throw 'found t))))
          nil)))))

;; Helper: Append BibTeX entry to file
(defun helm-gscholar--append-to-bib-file (bibtex-entry bib-file)
  "Append BIBTEX-ENTRY to BIB-FILE."
  (let ((dir (file-name-directory bib-file)))
    (when (and dir (not (file-exists-p dir)))
      (make-directory dir t))
    (with-temp-buffer
      (when (file-exists-p bib-file)
        (insert-file-contents bib-file))
      (goto-char (point-max))
      (unless (or (bobp) (looking-back "\n\n" nil))
        (insert "\n\n"))
      (insert bibtex-entry)
      (insert "\n")
      (write-region (point-min) (point-max) bib-file))))

;; Helper: Get BibTeX for result index
(defun helm-gscholar--get-bibtex-for-index (idx)
  "Retrieve BibTeX entry for result at IDX."
  (or (gethash idx helm-gscholar--bibtex-cache)
      (let* ((bibtex-urls (gscholar-bibtex-google-scholar-bibtex-urls
                           helm-gscholar--search-results))
             (url (nth idx bibtex-urls))
             (bibtex (when url
                       (gscholar-bibtex-google-scholar-bibtex-content url))))
        (when bibtex
          (puthash idx bibtex helm-gscholar--bibtex-cache))
        bibtex)))

;; Helper: Extract snippets/abstracts from Google Scholar results
(defun helm-gscholar--google-scholar-snippets (buffer-content)
  "Extract snippet text from Google Scholar BUFFER-CONTENT."
  (gscholar-bibtex-re-search
   buffer-content
   "<div class=\"gs_rs\">\\(.*?\\)</div>" 1))

;; Debug function - run this to test
(defun helm-gscholar--debug (query)
  "Debug search for QUERY - shows intermediate values."
  (interactive "sDebug search: ")
  (require 'gscholar-bibtex)
  (let* ((results (gscholar-bibtex-google-scholar-search-results query))
         (titles (gscholar-bibtex-google-scholar-titles results))
         (subtitles (gscholar-bibtex-google-scholar-subtitles results))
         (snippets (helm-gscholar--google-scholar-snippets results)))
    (with-current-buffer (get-buffer-create "*gscholar-debug*")
      (erase-buffer)
      (insert (format "=== Query: %s ===\n\n" query))
      (insert (format "Results length: %s\n" (length results)))
      (insert (format "Results type: %s\n" (type-of results)))
      (insert (format "Results empty string?: %s\n\n" (and (stringp results) (string= "" results))))
      (insert (format "Titles (%d): %S\n\n" (length titles) titles))
      (insert (format "Subtitles (%d): %S\n\n" (length subtitles) subtitles))
      (insert (format "Snippets (%d): %S\n\n" (length snippets) snippets))
      (insert "=== Raw results (first 2000 chars) ===\n")
      (insert (truncate-string-to-width (format "%s" results) 2000))
      (display-buffer (current-buffer)))))

;; Search function
(defun helm-gscholar--search (query)
  "Search Google Scholar for QUERY and return candidates."
  (require 'gscholar-bibtex)
  (clrhash helm-gscholar--bibtex-cache)
  (setq helm-gscholar--search-results
        (gscholar-bibtex-google-scholar-search-results query))
  (if (or (null helm-gscholar--search-results)
          (string= "" helm-gscholar--search-results))
      (progn (message "No results from Google Scholar (may be rate limited)")
             nil)
    (let* ((titles (gscholar-bibtex-google-scholar-titles
                    helm-gscholar--search-results))
           (subtitles (gscholar-bibtex-google-scholar-subtitles
                       helm-gscholar--search-results))
           (snippets (helm-gscholar--google-scholar-snippets
                      helm-gscholar--search-results)))
      (if (null titles)
          (progn (message "No results found or blocked by Google Scholar")
                 nil)
        (cl-loop for idx from 0 below (length titles)
                 collect (cons (format "%s\n    %s\n    %s"
                                       (propertize (or (nth idx titles) "No title") 'face 'bold)
                                       (propertize (or (nth idx subtitles) "") 'face 'font-lock-keyword-face)
                                       (propertize (truncate-string-to-width (or (nth idx snippets) "") 120)
                                                   'face 'font-lock-comment-face))
                               idx))))))

;; Action: Insert citation and add to bib
(defun helm-gscholar--action-cite (candidate)
  "Insert citation for CANDIDATE and add entry to local bib file."
  (let* ((idx candidate)
         (bibtex-str (helm-gscholar--get-bibtex-for-index idx))
         (entry (helm-gscholar--parse-bibtex-string bibtex-str))
         (key (cdr (assoc "=key=" entry)))
         (title (cdr (assoc "title" entry)))
         (bib-file (or (with-helm-current-buffer
                         (helm-gscholar--find-local-bib-file))
                       (car bibtex-completion-bibliography))))
    (unless bibtex-str
      (user-error "Could not retrieve BibTeX entry"))
    (unless bib-file
      (setq bib-file (read-file-name "Select bibliography file: " nil nil nil ".bib")))
    (if (helm-gscholar--entry-exists-p title bib-file)
        (message "Entry \"%s\" already exists in %s"
                 (truncate-string-to-width (or title "untitled") 40) bib-file)
      (helm-gscholar--append-to-bib-file bibtex-str bib-file)
      (message "Added entry to %s" bib-file))
    (with-helm-current-buffer
      (insert (format "\\cite{%s}" key)))))

;; Action: Show BibTeX
(defun helm-gscholar--action-show-bibtex (candidate)
  "Show BibTeX entry for CANDIDATE."
  (let ((bibtex-str (helm-gscholar--get-bibtex-for-index candidate)))
    (if bibtex-str
        (with-current-buffer (get-buffer-create "*gscholar-bibtex*")
          (erase-buffer)
          (insert bibtex-str)
          (bibtex-mode)
          (goto-char (point-min))
          (display-buffer (current-buffer)))
      (message "Could not retrieve BibTeX entry"))))

;; Action: Copy BibTeX
(defun helm-gscholar--action-copy-bibtex (candidate)
  "Copy BibTeX entry for CANDIDATE to kill ring."
  (let ((bibtex-str (helm-gscholar--get-bibtex-for-index candidate)))
    (if bibtex-str
        (progn
          (kill-new bibtex-str)
          (message "BibTeX entry copied to kill ring"))
      (message "Could not retrieve BibTeX entry"))))

;; Main command
;;;###autoload
(defun helm-gscholar-cite (query)
  "Search Google Scholar for QUERY and insert citation.
Prompts for search query, displays results in Helm.
On selection, adds BibTeX entry to local bibliography and inserts \\cite{key}."
  (interactive "sGoogle Scholar search: ")
  (require 'gscholar-bibtex)
  (require 'helm)
  (setq helm-gscholar--current-query query)
  ;; Perform search and get candidates
  (let ((candidates (helm-gscholar--search query)))
    (if (null candidates)
        (message "No results found for: %s" query)
      (helm :sources
            (helm-build-sync-source "Google Scholar"
              :candidates candidates
              :multiline t
              :action (helm-make-actions
                       "Insert citation and add to bib" #'helm-gscholar--action-cite
                       "Show BibTeX entry" #'helm-gscholar--action-show-bibtex
                       "Copy BibTeX to kill ring" #'helm-gscholar--action-copy-bibtex)
              :persistent-action #'helm-gscholar--action-show-bibtex
              :persistent-help "Preview BibTeX entry")
            :buffer "*helm gscholar*"
            :prompt "Select paper: "))))

;; Keybinding for LaTeX mode
(with-eval-after-load 'latex
  (define-key LaTeX-mode-map (kbd "C-c s") #'helm-gscholar-cite))

;; Auto-complete for LaTeX
(use-package ac-math
  :defer t)
(defun my-ac-latex-mode ()
  "Add ac-sources for latex."
  (require 'ac-math)
  (setq ac-sources
        (append '(ac-source-math-unicode
                  ac-source-math-latex
                  ac-source-latex-commands)
                ac-sources)))
(add-hook 'LaTeX-mode-hook 'my-ac-latex-mode)
(setq ac-math-unicode-in-math-p t)

(provide 'init-latex)
;;; init-latex.el ends here
