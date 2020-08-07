


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; MELPA ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'package)
;; (add-to-list 'package-archives
;;              '("melpa" . "https://melpa.org/packages/") t)
;; (add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)

(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives '("marmalade" . "https://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(package-initialize)
;; (package-initialize)
;;;; custom elpy files
;; (add-to-list 'load-path
;;              "~/.emacs.d/plugins")

(add-to-list 'load-path
             "/usr/local/share/emacs/site-lisp/rtags")
;;;;;;
(require 'req-package)
;;;; change graphene meta theme

(use-package graphene)


;; unset useless key bindings from graphene

(global-unset-key (kbd "C-."))

;; ;; if you want font change ever
;; (set-face-attribute 'default nil :font "inconsolata 11" ) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End MELPA ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package org2jekyll)
;; (use-package blog)

;;;;;; arxiv-mode


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Graphene  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; To get rid of that annoying error on startup
(setq byte-compile-warnings '(not free-vars ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End Graphene  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;; Exec from shell ;;;;;;;
;; Makes sure that the same configuration exists in shell as well as within emacs
;; This is helpful for programs that rely on packages that have dependencies outside emacs


;; (when (memq window-system '(mac ns x))
;;   (exec-path-from-shell-initialize))









;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Extras ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package helm-config)
(use-package rainbow-delimiters)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End Extras ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; disables annoying aspects ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)
;; use tab to move out
(defun eide-smart-tab-jump-out-or-indent (&optional arg)
  "Smart tab behavior. J(use-package org2jekyll)
(use-package blog)ump out quote or brackets, or indent."
  (interactive "P")
  (if (-contains? (list "\"" "'" ")" "}" ";" "|" ">" "]" ) (make-string 1 (char-after)))
      (forward-char 1)
    (indent-for-tab-command arg)))
(global-set-key [remap indent-for-tab-command]
                'eide-smart-tab-jump-out-or-indent)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; end disable annoying aspects ;;;;;;;;;;;;;;;;
(setq-default mode-require-final-newline nil)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; getting rid of graphene try ;;;;;;
;; ;; graphene packages
;; (require 'smex) ; Not needed if you use package.el
;; (smex-initialize) ; Can be omitted. This might cause a (minimal) delay
;; 					; when Smex is auto-initialized on its first run
;; ; autocomplete everything


;; ;; completing parentheses
;; (require 'smartparens-config)
;; (add-hook 'js-mode-hook #'smartparens-mode)
;; ;; Autocomplete with company-mode
(add-hook 'after-init-hook 'global-company-mode)

(defun my/python-mode-hook ()
  (add-to-list 'company-backends '(company-jedi company-files          ; files & directory
                                                company-keywords       ; keywords
                                                company-capf
                                                company-yasnippet
                                                company-abbrev
                                                company-dabbrev)))

(add-hook 'python-mode-hook 'my/python-mode-hook)

;; ;; Web mode for html pages
;; (require 'web-mode)
;; (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
;; ;; ido mode simplifies stuff
;; (require 'ido)
;; (ido-mode t)
;; ;; fly-check mode for stuff
;; (global-flycheck-mode)
(setq inhibit-startup-screen t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; get rid of graphene try ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(LaTeX-math-abbrev-prefix "'")
 '(LaTeX-math-list (quote (("1" "circ" "functions" nil))))
 '(TeX-PDF-mode t)
 '(TeX-insert-braces nil)
 '(TeX-source-correlate-method (quote ((dvi . source-specials) (pdf . synctex))))
 '(TeX-source-correlate-mode t)
 '(TeX-view-program-selection
   (quote
    ((output-pdf "Evince")
     ((output-dvi style-pstricks)
      "dvips and gv")
     (output-dvi "xdvi")
     (output-pdf "Evince")
     (output-html "xdg-open"))))
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#073642" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#657b83"])
 '(beacon-color "#ff9da4")
 '(c-basic-offset 4)
 '(compilation-message-face (quote default))
 '(cua-global-mark-cursor-color "#2aa198")
 '(cua-normal-cursor-color "#839496")
 '(cua-overwrite-cursor-color "#b58900")
 '(cua-read-only-cursor-color "#859900")
 '(cursor-type t)
 '(custom-enabled-themes (quote (solarized-light)))
 '(custom-safe-themes
   (quote
    ("dde8c620311ea241c0b490af8e6f570fdd3b941d7bc209e55cd87884eb733b0e" "c83c095dd01cde64b631fb0fe5980587deec3834dc55144a6e78ff91ebc80b19" "e1ef2d5b8091f4953fe17b4ca3dd143d476c106e221d92ded38614266cea3c8b" "2809bcb77ad21312897b541134981282dc455ccd7c14d74cc333b6e549b824f3" "c433c87bd4b64b8ba9890e8ed64597ea0f8eb0396f4c9a9e01bd20a04d15d358" "285d1bf306091644fb49993341e0ad8bafe57130d9981b680c1dbd974475c5c7" "51ec7bfa54adf5fff5d466248ea6431097f5a18224788d0bd7eb1257a4f7b773" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "e074be1c799b509f52870ee596a5977b519f6d269455b84ed998666cf6fc802a" "7f791f743870983b9bb90c8285e1e0ba1bf1ea6e9c9a02c60335899ba20f3c94" "7f6d4aebcc44c264a64e714c3d9d1e903284305fd7e319e7cb73345a9994f5ef" default)))
 '(elfeed-feeds (quote ("https://xkcd.com/rss.xml")))
 '(elfeed-show-entry-author t)
 '(fci-rule-color "#073642")
 '(flycheck-color-mode-line-face-to-color (quote mode-line-buffer-id))
 '(font-latex-math-environments
   (quote
    ("display" "displaymath" "equation" "eqnarray" "gather" "multline" "align" "alignat" "xalignat" "empheq")))
 '(fringe-mode 6 nil (fringe))
 '(helm-completion-style (quote emacs))
 '(highlight-changes-colors (quote ("#d3869b" "#8f3f71")))
 '(highlight-symbol-colors
   (quote
    ("#eca7d1029ac0" "#d5cfdbc8aed7" "#eaa6bb6792aa" "#e0ddc362b133" "#e32ad9af9d49" "#ee3ac34a94bf" "#c5a0cc76b306")))
 '(highlight-symbol-foreground-color "#665c54")
 '(highlight-tail-colors
   (quote
    (("#ebdbb2" . 0)
     ("#c6c148" . 20)
     ("#82cc73" . 30)
     ("#5b919b" . 50)
     ("#e29a3f" . 60)
     ("#df6835" . 70)
     ("#f598a7" . 85)
     ("#ebdbb2" . 100))))
 '(hl-bg-colors
   (quote
    ("#e29a3f" "#df6835" "#cf5130" "#f598a7" "#c2608f" "#5b919b" "#82cc73" "#c6c148")))
 '(hl-fg-colors
   (quote
    ("#fbf1c7" "#fbf1c7" "#fbf1c7" "#fbf1c7" "#fbf1c7" "#fbf1c7" "#fbf1c7" "#fbf1c7")))
 '(hl-paren-colors (quote ("#689d6a" "#b57614" "#076678" "#8f3f71" "#98971a")))
 '(hl-todo-keyword-faces
   (quote
    (("TODO" . "#dc752f")
     ("NEXT" . "#dc752f")
     ("THEM" . "#2d9574")
     ("PROG" . "#4f97d7")
     ("OKAY" . "#4f97d7")
     ("DONT" . "#f2241f")
     ("FAIL" . "#f2241f")
     ("DONE" . "#86dc2f")
     ("NOTE" . "#b1951d")
     ("KLUDGE" . "#b1951d")
     ("HACK" . "#b1951d")
     ("TEMP" . "#b1951d")
     ("FIXME" . "#dc752f")
     ("XXX+" . "#dc752f")
     ("\\?\\?\\?+" . "#dc752f"))))
 '(jdee-db-active-breakpoint-face-colors (cons "#F0F4FC" "#5d86b6"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#F0F4FC" "#4F894C"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#F0F4FC" "#B8C5DB"))
 '(linum-format (quote dynamic))
 '(lsp-ui-doc-border "#586e75")
 '(magit-diff-use-overlays nil)
 '(mc/always-run-for-all nil)
 '(nrepl-message-colors
   (quote
    ("#dc322f" "#cb4b16" "#b58900" "#546E00" "#B4C342" "#00629D" "#2aa198" "#d33682" "#6c71c4")))
 '(objed-cursor-color "#ff5d38")
 '(org-agenda-files (quote ("~/Dropbox/todo.org")))
 '(org-fontify-done-headline t)
 '(org-fontify-quote-and-verse-blocks t)
 '(org-fontify-whole-heading-line t)
 '(org-html-postamble-format
   (quote
    (("en" "<p class=\"author\">Author: Praharsh Suryadevara </p>
<p class=\"date\">Date: %d</p>
<p class=\"creator\">%c</p>"))))
 '(org-journal-dir "~/Dropbox/journal/")
 '(org-publish-project-alist
   (\`
    (("default" :base-directory
      (\,
       (org2jekyll-input-directory))
      :base-extension "org" :publishing-directory
      (\,
       (org2jekyll-output-directory))
      :publishing-function org-html-publish-to-html :headline-levels 4 :section-numbers nil :with-toc nil :html-head "<link rel=\"stylesheet\" href=\"./css/style.css\" type=\"text/css\"/>" :html-preamble t :recursive t :make-index t :html-extension "html" :body-only t)
     ("post" :base-directory
      (\,
       (org2jekyll-input-directory))
      :base-extension "org" :publishing-directory
      (\,
       (org2jekyll-output-directory org2jekyll-jekyll-posts-dir))
      :publishing-function org-html-publish-to-html :headline-levels 4 :section-numbers nil :with-toc nil :html-head "<link rel=\"stylesheet\" href=\"./css/style.css\" type=\"text/css\"/>" :html-preamble t :recursive t :make-index t :html-extension "html" :body-only t)
     ("images" :base-directory
      (\,
       (org2jekyll-input-directory "img"))
      :base-extension "jpg\\|gif\\|png" :publishing-directory
      (\,
       (org2jekyll-output-directory "img"))
      :publishing-function org-publish-attachment :recursive t)
     ("js" :base-directory
      (\,
       (org2jekyll-input-directory "js"))
      :base-extension "js" :publishing-directory
      (\,
       (org2jekyll-output-directory "js"))
      :publishing-function org-publish-attachment :recursive t)
     ("css" :base-directory
      (\,
       (org2jekyll-input-directory "css"))
      :base-extension "css\\|el" :publishing-directory
      (\,
       (org2jekyll-output-directory "css"))
      :publishing-function org-publish-attachment :recursive t)
     ("web" :components
      ("images" "js" "css")))))
 '(org2jekyll-blog-author "ardumont" nil (org2jekyll))
 '(org2jekyll-jekyll-directory (expand-file-name "~/public_html") nil (org2jekyll))
 '(org2jekyll-jekyll-drafts-dir "" nil (org2jekyll))
 '(org2jekyll-jekyll-posts-dir "_posts/" nil (org2jekyll))
 '(org2jekyll-source-directory (expand-file-name "~/website") nil (org2jekyll))
 '(package-selected-packages
   (quote
    (flycheck-irony company-jedi helm-company company-irony company-math langtool irony org-bullets helm-projectile cmake-mode cmake-ide ess ein jupyter ac-helm helm-rtags flycheck-rtags company-rtags ac-rtags ggtags function-args origami alert all-the-icons auctex biblio biblio-core company dash elfeed find-file-in-project flycheck ghub git-commit helm helm-core ht hydra ido-completing-read+ ivy sublimity smooth-scrolling command-log-mode writeroom-mode atom-one-dark-theme dracula-theme yasnippet-snippets helm-swoop oceanic-theme green-phosphor-theme solarized-theme julia-mode espresso-theme cherry-blossom-theme anzu paradox python-mode xkcd screenshot dashboard projectile spacemacs-theme neotree org-ac all-the-icons-dired spaceline-all-the-icons evil doom-themes dad-joke ac-math org-alert dired-quick-sort aggressive-indent emojify dired+ json-mode yaml-mode org2jekyll magit helm-tramp helm-bibtex htmlize xbm-life rainbow-blocks flycheck-cython cython-mode edit-server elpy mu4e-maildirs-extension look-mode undo-tree rainbow-delimiters org-journal multiple-cursors leuven-theme haskell-mode graphene goto-last-change d-mode cyberpunk-theme color-theme-sanityinc-tomorrow color-theme auto-complete-auctex auctex-lua auctex-latexmk 4clojure)))
 '(paradox-github-token t)
 '(pdf-view-midnight-colors (quote ("#DCDCCC" . "#383838")))
 '(pos-tip-background-color "#073642")
 '(pos-tip-foreground-color "#93a1a1")
 '(rustic-ansi-faces
   ["#E5E9F0" "#99324B" "#4F894C" "#9A7500" "#3B6EA8" "#97365B" "#398EAC" "#3B4252"])
 '(smartrep-mode-line-active-bg (solarized-color-blend "#859900" "#073642" 0.2))
 '(spaceline-all-the-icons-clock-always-visible t)
 '(spaceline-all-the-icons-flycheck-alternate t)
 '(spaceline-all-the-icons-highlight-file-name t)
 '(spaceline-all-the-icons-icon-set-git-ahead (quote commit))
 '(spaceline-all-the-icons-icon-set-vc-icon-git (quote git-logo))
 '(spaceline-all-the-icons-separator-type (quote arrow))
 '(spaceline-all-the-icons-separators-invert-direction t)
 '(tab-width 4)
 '(term-default-bg-color "#002b36")
 '(term-default-fg-color "#839496")
 '(vc-annotate-background nil)
 '(vc-annotate-background-mode nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#dc322f")
     (40 . "#c8805d801780")
     (60 . "#bec073400bc0")
     (80 . "#b58900")
     (100 . "#a5008e550000")
     (120 . "#9d0091000000")
     (140 . "#950093aa0000")
     (160 . "#8d0096550000")
     (180 . "#859900")
     (200 . "#66aa9baa32aa")
     (220 . "#57809d004c00")
     (240 . "#48559e556555")
     (260 . "#392a9faa7eaa")
     (280 . "#2aa198")
     (300 . "#28669833af33")
     (320 . "#279993ccbacc")
     (340 . "#26cc8f66c666")
     (360 . "#268bd2"))))
 '(vc-annotate-very-old-color nil)
 '(weechat-color-list
   (quote
    (unspecified "#002b36" "#073642" "#990A1B" "#dc322f" "#546E00" "#859900" "#7B6000" "#b58900" "#00629D" "#268bd2" "#93115C" "#d33682" "#00736F" "#2aa198" "#839496" "#657b83")))
 '(xterm-color-names
   ["#073642" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#eee8d5"])
 '(xterm-color-names-bright
   ["#002b36" "#cb4b16" "#586e75" "#657b83" "#839496" "#6c71c4" "#93a1a1" "#fdf6e3"]))


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(preview-reference-face ((t (:foreground "black")))))





(use-package preview
  :commands LaTeX-preview-setup
  :init
  (setq-default preview-scale 1.4
                preview-scale-function '(lambda () (* (/ 10.0 (preview-document-pt)) preview-scale))))

;; (load-theme 'dracula-theme)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; python Config ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(package-initialize)


(pyvenv-activate "/home/praharsh/anaconda3")
(setq elpy-rpc-python-command "/home/praharsh/anaconda3/bin/python")
;; (setq elpy-rpc-pythonpath "/home/praharsh/Dropbox/research/bv-libraries/mcpele1")
(elpy-enable)
(setq flycheck-python-flake8-executable "flake8")


;; (setq elpy-rpc-python-command "~/py2/bin/./python")
;; (elpy-use-cpython "~/py2/bin/./python")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End Elpy Config ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; C++ Config ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;; ggtags Work until rtags gets fixed


;; (req-package rtags)

;; (add-hook 'c-mode-common-hook
;;           (lambda ()
;;             (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
;;               (ggtags-mode 1))))


;; (define-key ggtags-mode-map (kbd "C-c g s") 'ggtags-find-other-symbol)
;; (define-key ggtags-mode-map (kbd "C-c g h") 'ggtags-view-tag-history)
;; (define-key ggtags-mode-map (kbd "C-c g r") 'ggtags-find-reference)
;; (define-key ggtags-mode-map (kbd "C-c g f") 'ggtags-find-file)
;; (define-key ggtags-mode-map (kbd "C-c g c") 'ggtags-create-tags)
;; (define-key ggtags-mode-map (kbd "C-c g u") 'ggtags-update-tags)

;; (define-key ggtags-mode-map (kbd "M-,") 'pop-tag-mark)


;; end ggtags




;; UNDER CONSTRUCTION
;; This uses rtags to implement C++ ide features 
;; For installation help check https://github.com/Andersbakken/rtags






(use-package rtags
  :config
  (progn
    (unless (rtags-executable-find "rc") (error "Binary rc is not installed!"))
    (unless (rtags-executable-find "rdm") (error "Binary rdm is not installed!"))

    (define-key c-mode-base-map (kbd "M-.") 'rtags-find-symbol-at-point)
    (define-key c-mode-base-map (kbd "M-,") 'rtags-find-references-at-point)
    (define-key c-mode-base-map (kbd "M-?") 'rtags-display-summary)
    (rtags-enable-standard-keybindings)
    (setq rtags-completions-enabled t)
    (setq rtags-use-helm t)

    ;; Shutdown rdm when leaving emacs.
    (add-hook 'kill-emacs-hook 'rtags-quit-rdm)
    )
  :bind (("C-. r D" . rtags-dependency-tree)
         ("C-. r F" . rtags-fixit)
         ("C-. r R" . rtags-rename-symbol)
         ("C-. r T" . rtags-tagslist)
         ("C-. r d" . rtags-create-doxygen-comment)
         ("C-. r c" . rtags-display-summary)
         ("C-. r e" . rtags-print-enum-value-at-point)
         ("C-. r f" . rtags-find-file)
         ("C-. r i" . rtags-include-file)
         ("C-. r i" . rtags-symbol-info)
         ("C-. r m" . rtags-imenu)
         ("C-. r n" . rtags-next-match)
         ("C-. r p" . rtags-previous-match)
         ("C-. r r" . rtags-find-references)
         ("C-. r s" . rtags-find-symbol)
         ("C-. r v" . rtags-find-virtuals-at-point))
  )

(add-hook 'c-mode-hook 'rtags-start-process-unless-running)
(add-hook 'c++-mode-hook 'rtags-start-process-unless-running)
(add-hook 'objc-mode-hook 'rtags-start-process-unless-running)
(cmake-ide-setup)

(add-hook 'c++-mode-hook 'irony-mode)
(req-package helm-rtags
  :require helm rtags
  :config
  (progn
    (setq rtags-display-result-backend 'helm)
    ))

;; use irony for autocompletion



(setq company-backends
      '((company-files          ; files & directory
         company-keywords       ; keywords
         company-capf
         company-yasnippet
         company-abbrev
         company-dabbrev
         )
        ))
(dolist (hook '(c-mode-hook
                c++-mode-hook
                objc-mode-hook
                ))
  (add-hook hook
            (lambda()
              (make-local-variable 'company-backends)
              (setq company-backends (copy-tree company-backends))
              (setf (car company-backends)
                    (append '(company-irony)
                            (car company-backends)))
              ))
  )



(eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))

;; ;; Live code checking.
;; (req-package flycheck-rtags
;;   :require flycheck rtags
;;   :config
;;   (progn
;;     ;; ensure that we use only rtags checking
;;     ;; https://github.com/Andersbakken/rtags#optional-1
;;     (defun setup-flycheck-rtags ()
;;       (flycheck-select-checker 'rtags)
;;       (setq-local flycheck-highlighting-mode nil) ;; RTags creates more accurate overlays.
;;       (setq-local flycheck-check-syntax-automatically nil)
;;       (rtags-set-periodic-reparse-timeout 4.0)  ;; Run flycheck 2 seconds after being idle.
;;       )
;;     (add-hook 'c-mode-hook #'setup-flycheck-rtags)
;;     (add-hook 'c++-mode-hook #'setup-flycheck-rtags)
;;     ))



;; do not indent in namespaces
;; (defconst my-cc-style
;;   '("cc-mode"
;;     (c-offsets-alist . ((innamespace . [0])))))

;; (c-add-style "my-cc-mode" my-cc-style)


(c-set-offset 'innamespace 0)




(use-package langtool
  :defer 1
  :config
  ;; install with `brew install languagetool`
  (setq langtool-language-tool-server-jar "/home/praharsh/Dropbox/LanguageTool-5.0/languagetool-server.jar")
  (setq langtool-java-bin "/usr/bin/java")
  (setq langtool-default-language "en-US"))

;; (req-package helm-rtags
;;   :require helm rtags
;;   :config
;;   (progn
;;     (setq rtags-display-result-backend 'helm)
;;     ))

;; Use rtags for auto-completion.
(req-package company-rtags
  :require company rtags
  :config
  (progn
    (setq rtags-autostart-diagnostics t)
    (rtags-diagnostics)
    (company-mode)
    (setq rtags-completions-enabled t)
    (push 'company-rtags company-backends)
    ))

;; ;; Live code checking.
;; (req-package flycheck-rtags
;;   :require flycheck rtags
;;   :config
;;   (progn
;;     ;; ensure that we use only rtags checking
;;     ;; https://github.com/Andersbakken/rtags#optional-1
;;     (defun setup-flycheck-rtags ()
;;       (flycheck-select-checker 'rtags)
;;       (setq-local flycheck-highlighting-mode nil) ;; RTags creates more accurate overlays.
;;       (setq-local flycheck-check-syntax-automatically nil)
;;       (rtags-set-periodic-reparse-timeout 2.0)  ;; Run flycheck 2 seconds after being idle.
;;       )
;;     (add-hook 'c-mode-hook #'setup-flycheck-rtags)
;;     (add-hook 'c++-mode-hook #'setup-flycheck-rtags)
;;     ))
;; ;; (require 'rtags)



;; Shell setup

;; (global-set-key (kbd "<f9>") 'eshell)





;; origami
;; TODO:: Set up origami
(req-package origami)






 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (add-to-list 'load-path
;;              "~/.emacs.d/plugins/yasnippet") 

(use-package yasnippet)
(yas-global-mode 1)
(define-key yas-minor-mode-map (kbd "<C-tab>") 'yas-expand)


(use-package auctex
  :defer t
  :ensure t)
;;;;;;;;;;;;;;;;;;;;;;;;; Latex Config

;; (add-to-list 'company-backends 'company-math-symbols-unicode)

;; Latex add environment to math mode
(add-hook 'LaTeX-mode-hook 'add-my-latex-environments)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)

;; (defun latex-company ()
;;   (setq-local company-backends
;;               (append '((company-math-symbols-latex company-latex-commands))
;;                       company-backends)))

(defun add-my-latex-environments () 
  (LaTeX-add-environments 
   '("empheq" LaTeX-env-label)))


;; (add-hook 'TeX-mode-hook 'my-latex-mode-setup)

(global-set-key "\C-x4w" 'langtool-check)
(global-set-key "\C-x4W" 'langtool-check-done)
(global-set-key "\C-x4l" 'langtool-switch-default-language)
(global-set-key "\C-x44" 'langtool-show-message-at-point)
(global-set-key "\C-x4c" 'langtool-correct-buffer)
(global-set-key (kbd "<kp-6>") 'langtool-goto-next-error)
(global-set-key (kbd "<kp-4>") 'langtool-goto-previous-error)


;; Code I added to make syntax highlighting work in Auctex 

;;Stops putting {} on argumentless commands to "save" whitespace 

;; Additionally, reftex code to recognize this environment as an equation 
(setq reftex-label-alist 
      '(("empheq" ?e nil nil t))) 


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





;; bibliography
(autoload 'helm-bibtex "helm-bibtex" "" t)
(setq reftex-default-bibliography '("~/Dropbox/biblio.bib"
                                    "~/Dropbox/cftbiblio.bib") )
(setq helm-bibtex-bibliography '("~/Dropbox/biblio.bib"
                                 "~/Dropbox/cftbiblio.bib"))
;; Why do I have this defined

(setq bibtex-completion-bibliography '("~/Dropbox/biblio.bib"
                                       "~/Dropbox/cftbiblio.bib"))

;;;;;;;;;;;;;;;;;;;;;;;;;; Latex config ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)


(use-package undo-tree)
(global-undo-tree-mode 1)
;; Helm commands
(global-set-key (kbd "M-x") #'helm-M-x)
(global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
(global-set-key (kbd "C-x C-f") #'helm-find-files)
(global-set-key (kbd "C-M-y") 'helm-show-kill-ring)

(helm-mode 1)



;; STOP POPUPS


(add-hook 'python-mode-hook (lambda () (auto-complete-mode -1)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Moving about ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;; ;;;; Helm Swoop


;; helm from https://github.com/emacs-helm/helm
(use-package helm)


;; autocomplete helm
(require 'ac-helm)  ;; Not necessary if using ELPA package
(global-set-key (kbd "C-:") 'ac-complete-with-helm)
(define-key ac-complete-mode-map (kbd "C-:") 'ac-complete-with-helm)

;; Flymake necessity

;; Locate the helm-swoop folder to your path
(add-to-list 'load-path "~/.emacs.d/elisp/helm-swoop")
(use-package helm-swoop)

;; Change the keybinds to whatever you like :)
(global-set-key (kbd "M-i") 'helm-swoop)
(global-set-key (kbd "M-I") 'helm-swoop-back-to-last-point)
(global-set-key (kbd "C-c M-i") 'helm-multi-swoop)
(global-set-key (kbd "C-x M-i") 'helm-multi-swoop-all)

;; When doing isearch, hand the word over to helm-swoop
(define-key isearch-mode-map (kbd "M-i") 'helm-swoop-from-isearch)
;; From helm-swoop to helm-multi-swoop-all
(define-key helm-swoop-map (kbd "M-i") 'helm-multi-swoop-all-from-helm-swoop)
;; When doing evil-search, hand the word over to helm-swoop
;; (define-key evil-motion-state-map (kbd "M-i") 'helm-swoop-from-evil-search)

;; Instead of helm-multi-swoop-all, you can also use helm-multi-swoop-current-mode
(define-key helm-swoop-map (kbd "M-m") 'helm-multi-swoop-current-mode-from-helm-swoop)

;; Move up and down like isearch
(define-key helm-swoop-map (kbd "C-r") 'helm-previous-line)
(define-key helm-swoop-map (kbd "C-s") 'helm-next-line)
(define-key helm-multi-swoop-map (kbd "C-r") 'helm-previous-line)
(define-key helm-multi-swoop-map (kbd "C-s") 'helm-next-line)

;; Save buffer when helm-multi-swoop-edit complete
(setq helm-multi-swoop-edit-save t)

;; If this value is t, split window inside the current window
(setq helm-swoop-split-with-multiple-windows nil)

;; Split direcion. 'split-window-vertically or 'split-window-horizontally
(setq helm-swoop-split-direction 'split-window-vertically)

;; If nil, you can slightly boost invoke speed in exchange for text color
(setq helm-swoop-speed-or-color nil)

;; ;; Go to the opposite side of line from the end or beginning of line
(setq helm-swoop-move-to-line-cycle t)

;; Optional face for line numbers
;; Face name is `helm-swoop-line-number-face`
(setq helm-swoop-use-line-number-face t)

;; If you prefer fuzzy matching
(setq helm-swoop-use-fuzzy-match nil)


;;;;;; end helm swoop ;;;;;;;;



;;;;;; Begin ace-jump-mode

;;
;; ace jump mode major function
;; 
(add-to-list 'load-path "/full/path/where/ace-jump-mode.el/in/")
(autoload
  'ace-jump-mode
  "ace-jump-mode"
  "Emacs quick move minor mode"
  t)
;; you can select the key you prefer to
(define-key global-map (kbd "<print>") 'ace-jump-mode)
(define-key global-map (kbd "<kp-0>") 'ace-jump-mode)



;; 
;; enable a more powerful jump back function from ace jump mode
;;
(autoload
  'ace-jump-mode-pop-mark
  "ace-jump-mode"
  "Ace jump back:-)"
  t)


;; (setq helm-projectile-fuzzy-match nil)
(require 'helm-projectile)
(helm-projectile-on)

(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

;; this makes sense
(eval-after-load "ace-jump-mode"
  '(ace-jump-mode-enable-mark-sync))
(define-key global-map (kbd "C-x SPC") 'ace-jump-mode-pop-mark)


;; end ace-jump mode





;; Multiple cursor commands
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)




;; macro commands
(global-set-key (kbd "<f5>") 'kmacro-cycle-ring-previous)
(global-set-key (kbd "<f6>") 'kmacro-cycle-ring-next)


;; global imenu command


(global-set-key (kbd "<f9>") 'imenu)

;;;;;;;;;; org mode commands ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(global-set-key "\C-cl" 'org-store-link)
(global-set-key (kbd "<f12>") 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cb" 'org-iswitchb)





;; Hide leading stars
(setq org-startup-indented t
      org-hide-leading-stars t)

(setq org-log-done 'time)
(setq org-log-done 'note)

;; org bullets
(use-package org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

;; use org journal
(use-package org-journal)




(setq org-agenda-window-setup 'only-window)
(global-set-key (kbd "<f10>") 'org-journal-new-entry)

;; org-mode themes
(setq org-fontify-whole-heading-line t)
(add-to-list 'org-modules 'org-habit t)
;; ;; CUSTOMIZE LATER
;; (setq org-todo-keyword-faces
;;       '(("TODO" . org-warning) ("STARTED" . "yellow")
;;         ("CANCELED" . (:foreground "blue" :weight bold))))

;; Changes TODO Keywords and logs states
(setq org-todo-keywords
      '((sequence "TODO(t)" "WAIT(w@/!)" "|" "DONE(d@)" "CANCELED(c@)")))
;; persist emacs history
(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)

;; highlights math
(setq org-highlight-latex-and-related '(latex script entities))


;; Org mode autoarchive from john wiegley
(defvar org-my-archive-expiry-days 2
  "The number of days after which a completed task should be auto-archived.
This can be 0 for immediate, or a floating point value.")

(defun org-my-archive-done-tasks ()
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
(setq org-default-notes-file (concat org-directory "/todo.org"))
(setq org-capture-templates
      '(("t" "todo" entry (file+headline "~/Dropbox/todo.org" "Tasks")
         "* TODO [#A] %?\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+0d\"))\n%a\n")
        ("r" "Paper to Read" entry (file+headline "~/Dropbox/todo.org" "Research Reading")
         "* TOREAD [#C] %?\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+0d\"))\n%a\n")))
(defun bjm/org-capture-todo ()
  (interactive)
  "Capture a TODO item"
  (org-capture nil "t"))

;; bind
(define-key global-map (kbd "C-c t") 'bjm/org-capture-todo)


;;;; babel ;;;
(use-package org)
(use-package ox-latex)
(setq org-latex-create-formula-image-program 'dvipng)
(org-babel-do-load-languages 'org-babel-load-languages '((latex . t)))
(setq exec-path (append exec-path '("/usr/bin")))
;; (load "auctex.el" nil t t)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((latex . t) (python . t) (haskell . t) (emacs-lisp . t)))

(setq org-babel-python-command "~/miniconda2/envs/basemacs/bin/./python")
(add-hook 'after-init-hook 'org-agenda-list)

;; yasnippet cofiguration
(add-hook 'org-mode-hook
          (lambda ()
            (setq-local yas/trigger-key [tab])
            (define-key yas/keymap [tab] 'yas-next-field-or-maybe-expand)))
;; todo captures bound to key 


(setq yas-snippet-dirs '("~/.emacs.d/snippets"))



;;;;; org gcal integration with google-calendar ;;;

(use-package org-alert)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; end org mode ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; save emacs sessions


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; flycheck mode ;;;;;;;;;;;;;;;;;;;;;;
;; making flycheck not treat emacs as a package
(global-flycheck-mode)

'(flycheck-check-syntax-automatically (quote (save idle-change mode-
                                                   enabled)))
'(flycheck-idle-change-delay 10) ;; Set delay based on what suits you the best


;; Optional explicitly select the RTags Flycheck checker for c or c++ major mode.
;; Turn off Flycheck highlighting, use the RTags one.
;; Turn off automatic Flycheck syntax checking rtags does this manually.

;; the default value was '(save idle-change new-line mode-enabled)


;; code to load themes on


;; ;; disable other themes before loading new one
;; (defadvice load-theme (before theme-dont-propagate activate)
;;   "Disable theme before loading new one."
;;   (mapcar #'disable-theme custom-enabled-themes))






;; (defun haba/next-theme (theme)
;;   (if (eq theme 'default)
;;       (disable-theme *haba-current-theme*)
;;     (progn
;;       (load-theme theme t)))
;;   (setq *haba-current-theme* theme))

;; (defun haba/toggle-theme ()
;;   (interactive)
;;   (cond ((eq *haba-current-theme* *haba-theme-dark*) (haba/next-theme *haba-theme-light*))
;;         ((eq *haba-current-theme* *haba-theme-light*) (haba/next-theme 'default))
;;         ((eq *haba-current-theme* 'default) (haba/next-theme *haba-theme-dark*))))
;; disable-theme *haba-current-theme*


;;Mail client
;; (add-to-list 'auto-mode-alist '("/mutt" . mail-mode))
;; fix for python interpreter
(with-eval-after-load 'python
  (defun python-shell-completion-native-try ()
    "Return non-nil if can trigger native completion."
    (let ((python-shell-completion-native-enable t)
          (python-shell-completion-native-output-timeout
           python-shell-completion-native-try-output-timeout))
      (python-shell-completion-native-get-completions
       (get-buffer-process (current-buffer))
       nil "_"))))
;; Mails
;; org auto complete


;; Make config suit for you. About the config item, eval the following sexp.
;; (customize-group "org-ac")


;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Begin mu4e ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (add-to-list 'load-path "~/mu4e/share/emacs/site-lisp/mu4e")
;; (require 'mu4e)    
;; ;; these are actually the defaults mailditectory
;; (setq
;;  mu4e-maildir       "~/Maildir"   ;; top-level Maildir
;;  mu4e-sent-folder   "/[Gmail].Sent Mail"       ;; folder for sent messages
;;  mu4e-drafts-folder "/[Gmail].Drafts"     ;; unfinished messages
;;  mu4e-trash-folder  "/[Gmail].Trash"      ;; trashed messages
;;  mu4e-refile-folder "/archive")   ;; saved messages

;; (setq mu4e-compose-dont-reply-to-self t)

;; (setq send-mail-function    'smtpmail-send-it
;;       smtpmail-smtp-server  "smtp.gmail.com"
;;       smtpmail-stream-type  'ssl
;;       smtpmail-smtp-service 465)
;; (setq
;;  mu4e-get-mail-command "offlineimap"   ;; or fetchmail, or ...
;;  mu4e-update-interval 300)             ;; update every 5 minutes
;; (require 'gnus-dired)
;; ;; make the `gnus-dired-mail-buffers' function also work on
;; ;; message-mode derived modes, such as mu4e-compose-mode
;; (defun gnus-dired-mail-buffers ()
;;   "Return a list of active message buffers."
;;   (let (buffers)
;;     (save-current-buffer
;;       (dolist (buffer (buffer-list t))
;;         (set-buffer buffer)
;;         (when (and (derived-mode-p 'message-mode)
;;                    (null message-sent-message-via))
;;           (push (buffer-name buffer) buffers))))
;;     (nreverse buffers)))

;; (setq gnus-dired-mail-mode 'mu4e-user-agent)
;; (add-hook 'dired-mode-hook 'turn-on-gnus-dired-mode)
;; ;; org mode integration
;; (require 'org-mu4e)
;; (global-set-key (kbd "C-c m") 'mu4e)

;; ;; Skips displaying duplicates
;; (setq mu4e-headers-skip-duplicates t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End mu4e ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; browser
(require 'edit-server)
(edit-server-start)

;;;;;;; outfile for arbtt  ;;;;;;;
;;; gives information so that arbtt can process it
(setq frame-title-format "%f")
(global-set-key (kbd "C-x w") (lambda () (interactive) (elfeed) (elfeed-update)))
(global-set-key (kbd "C-c b") 'helm-buffers-list)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; rss ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (require 'elfeed)
;; (require 'elfeed-goodies)
;; (elfeed-goodies/setup)
;; ;; Load elfeed-org
;; (require 'elfeed-org)

;; (elfeed-org)
;; ;; Initialize elfeed-org
;; ;; This hooks up elfeed-org to read the configuration when elfeed
;; ;; is started with =M-x elfeed=

;; ;; Optionally specify a number of files containing elfeed
;; ;; configuration. If not set then the location below is used.
;; ;; Note: The customize interface is also supported.
;; (setq rmh-elfeed-org-files (list "~/.emacs.d/elfeed.org"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; add emojis :)
(add-hook 'after-init-hook #'global-emojify-mode)
;; works :P this is awesome.

;; aggressive indent
(global-aggressive-indent-mode 1)
(add-to-list 'aggressive-indent-excluded-modes 'html-mode)
;;
(use-package magithub
  :after magit
  :config (magithub-feature-autoinject t))
(use-package dired-quick-sort
  :ensure t
  :config
  (dired-quick-sort-setup))

;; cluster PBS commands
(setq auto-mode-interpreter-regexp 
      "#\\(?:!\\|PBS -S \\)[ \t]?\\([^ \t\n]*/bin/env[ \t]\\)?\\([^ \t\n]+\\)")
;;



;; stuff
(put 'set-goal-column 'disabled nil)


;;;;;;;;;;;;;;;;;; Haskell-mode ;;;;;;;;;;;;;;;;;;

(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)

;;;;;;;;;;;;;;;;; end Haskell-mode ;;;;;;;;;;;;;;;;;;







;;;;;;;;;;;;;;;;; All the icons ;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path
             "~/.emacs.d/plugins/alltheicons")
(use-package all-the-icons)
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
;;;; neotree
(use-package neotree)
(global-set-key [f8] 'neotree-toggle)
(setq neo-theme (if (display-graphic-p) 'icons 'arrow))





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;
(add-to-list 'load-path
             "~/.emacs.d/plugins/spaceline")
(use-package spaceline-config)

;; Paradox
(use-package paradox)
(paradox-enable)

;; anzu search
(use-package anzu)
(global-anzu-mode +1)



(spaceline-all-the-icons-theme)
(spaceline-all-the-icons--setup-anzu)            ;; Enable anzu searching
(spaceline-all-the-icons--setup-package-updates) ;; Enable package update indicator
(spaceline-all-the-icons--setup-git-ahead)       ;; Enable # of commits ahead of upstream in git
(spaceline-all-the-icons--setup-paradox)         ;; Enable Paradox mode line
(spaceline-all-the-icons--setup-neotree)  




;; Keyboard Maps



(setq user-full-name "Praharsh Suryadevara")
(setq user-mail-address "praharsharmm@gmail.com")
(projectile-mode)
;; (mu4e)
;; (elfeed-org)
;; (find-file "/home/praharsh/Dropbox/research/Journal.org")

;; startup hooks
(use-package dashboard
  :config
  (dashboard-setup-startup-hook))

(setq dashboard-banner-logo-title "Keep your hands dirty || Do calculations ||  Make notes")
(setq dashboard-startup-banner "~/Pictures/operator2.png")

(setq dashboard-items '((recents  . 5)
                        (agenda . 20)))



;; evil-mode
;; startup


(defun run-terminal ()
  "Launch application in a terminal emulator."
  (interactive)
  (start-process
   "termx"
   nil
   ;; Change this for your terminal.
   "gnome-terminal" "-e" (read-shell-command "Shell: ")

   ))



;; scrolling settings

;; (require 'sublimity)
;; (require 'sublimity-scroll)
;; (require 'sublimity-map) ;; experimental
;; (require 'sublimity-attractive)
;; (sublimity-mode 1)



;;; Font settings
(use-package auto-complete)
(add-to-list 'ac-modes 'latex-mode) ; beware of using 'LaTeX-mode instead
(use-package ac-math) ; package should be installed first 
(defun my-ac-latex-mode () ; add ac-sources for latex
  (setq ac-sources
        (append '(ac-source-math-unicode
                  ac-source-math-latex
                  ac-source-latex-commands)
                ac-sources)))
(add-hook 'LaTeX-mode-hook 'my-ac-latex-mode)
(setq ac-math-unicode-in-math-p t)
(ac-flyspell-workaround) ; fixes a known bug of delay due to flyspell (if it is there)
(add-to-list 'ac-modes 'org-mode) ; auto-complete for org-mode (optional)
(use-package auto-complete-config) ; should be after add-to-list 'ac-modes and hooks
(ac-config-default)
(setq ac-auto-start nil)            ; if t starts ac at startup automatically
(setq ac-auto-show-menu t)
(global-auto-complete-mode t)
(set-default 'preview-scale-function 1.2)



;; Set font

(set-face-attribute 'default t :font "-UKWN-SF Mono-normal-normal-extracondensed-*-14-*-*-*-m-0-iso10646-1")



;; (add-hook 'python-mode-hook 'writeroom-mode)


;; -----======= Fill Column Indicator
;; (require 'fill-column-indicator)

;; (setq fci-rule-width 1)
;; (setq fci-rule-color "midnight blue")
;; (defun sanityinc/fci-enabled-p () (symbol-value 'fci-mode))

;; (defvar sanityinc/fci-mode-suppressed nil)
;; (make-variable-buffer-local 'sanityinc/fci-mode-suppressed)

;; (defadvice popup-create (before suppress-fci-mode activate)
;;   "Suspend fci-mode while popups are visible"
;;   (let ((fci-enabled (sanityinc/fci-enabled-p)))
;;     (when fci-enabled
;;       (setq sanityinc/fci-mode-suppressed fci-enabled)
;;       (turn-off-fci-mode))))

;; (defadvice popup-delete (after restore-fci-mode activate)
;;   "Restore fci-mode when all popups have closed"
;;   (when (and sanityinc/fci-mode-suppressed
;;              (null popup-instances))
;;     (setq sanityinc/fci-mode-suppressed nil)
;;     (turn-on-fci-mode)))


;; (defun on-off-fci-before-company(command)
;;   (when (string= "show" command)
;;     (turn-off-fci-mode))
;;   (when (string= "hide" command)
;;     (turn-on-fci-mode)))

;; (advice-add 'company-call-frontends :before #'on-off-fci-before-company)
;; Frame font




(define-key company-active-map (kbd "C-s") 'company-complete-common-or-cycle)
(define-key company-active-map (kbd "C-r") 'company-select-previous-or-abort)

;; mcpele pele stuff

(setenv "PYTHONPATH"
        (concat
         "/home/praharsh/Dropbox/stefano/mcpele" ":"
         "/home/praharsh/Dropbox/stefano/pele" 
         )
        )






