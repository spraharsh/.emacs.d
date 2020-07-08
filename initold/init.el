


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
;;;; custom elpy files
(add-to-list 'load-path
             "~/.emacs.d/plugins")
;;;;;;

;;;; change graphene meta theme
(use-package graphene)
;; ;; if you want font change ever
;; (set-face-attribute 'default nil :font "inconsolata 11" ) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End MELPA ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package org2jekyll)
(use-package blog)

;;;;;; arxiv-mode


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Graphene  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; To get rid of that annoying error on startup
(setq byte-compile-warnings '(not free-vars ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End Graphene  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; arxiv-reader  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; end arxiv-reader  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
;; (add-hook 'after-init-hook 'global-company-mode)
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
 '(compilation-message-face (quote default))
 '(cua-global-mark-cursor-color "#2aa198")
 '(cua-normal-cursor-color "#839496")
 '(cua-overwrite-cursor-color "#b58900")
 '(cua-read-only-cursor-color "#859900")
 '(cursor-type t)
 '(custom-enabled-themes (quote (solarized-dark)))
 '(custom-safe-themes
   (quote
    ("0598c6a29e13e7112cfbc2f523e31927ab7dce56ebb2016b567e1eff6dc1fd4f" "028de01489a683696c64dcc2a01eaa663670d04202de3fce48ec3a5542bc2da5" "fa2af0c40576f3bde32290d7f4e7aa865eb6bf7ebe31eb9e37c32aa6f4ae8d10" "78496062ff095da640c6bb59711973c7c66f392e3ac0127e611221d541850de2" "1c082c9b84449e54af757bcae23617d11f563fc9f33a832a8a2813c4d7dfb652" "2c88b703cbe7ce802bf6f0bffe3edbb8d9ec68fc7557089d4eaa1e29f7529fe1" "6b289bab28a7e511f9c54496be647dc60f5bd8f9917c9495978762b99d8c96a0" "ecba61c2239fbef776a72b65295b88e5534e458dfe3e6d7d9f9cb353448a569e" "a4df5d4a4c343b2712a8ed16bc1488807cd71b25e3108e648d4a26b02bc990b3" "151bde695af0b0e69c3846500f58d9a0ca8cb2d447da68d7fbf4154dcf818ebc" "b01b91ba9276deb39aa892c105a8644ef281b4d1804ab7c48de96e9c5d2aaa48" "a156fcac344bbfdc979a5adf9cecf1c2de56c4c937549ae0571b7f11ad4fe6a9" "9d9fda57c476672acd8c6efeb9dc801abea906634575ad2c7688d055878e69d6" "ce3e6c12b48979ce89754884d913c7ecc8a7956543d8b09ef13abfab6af9aa35" "3a3de615f80a0e8706208f0a71bbcc7cc3816988f971b6d237223b6731f91605" "77bddca0879cb3b0ecdf071d9635c818827c57d69164291cb27268ae324efa84" "554b7f0439155d6eb648d4837ef03902f51124cacee021217e76f39e9dd314c2" "2e1d19424153d41462ad31144549efa41f55dacda9b76571f73904612b15fd0a" "0a3a41085c19d8121ed0ad3eb658a475ccb948a70a83604641ee7d4c3575a4d5" "9a155066ec746201156bb39f7518c1828a73d67742e11271e4f24b7b178c4710" "4486ade2acbf630e78658cd6235a5c6801090c2694469a2a2b4b0e12227a64b9" "6f11ad991da959fa8de046f7f8271b22d3a97ee7b6eca62c81d5a917790a45d9" "d6922c974e8a78378eacb01414183ce32bc8dbf2de78aabcc6ad8172547cb074" "c158c2a9f1c5fcf27598d313eec9f9dceadf131ccd10abc6448004b14984767c" "fa2b58bb98b62c3b8cf3b6f02f058ef7827a8e497125de0254f56e373abee088" "4af6fad34321a1ce23d8ab3486c662de122e8c6c1de97baed3aa4c10fe55e060" "5acb6002127f5d212e2d31ba2ab5503df9cd1baa1200fbb5f57cc49f6da3056d" "cc60d17db31a53adf93ec6fad5a9cfff6e177664994a52346f81f62840fe8e23" "5cd0afd0ca01648e1fff95a7a7f8abec925bd654915153fb39ee8e72a8b56a1f" "c72a772c104710300103307264c00a04210c00f6cc419a79b8af7890478f380e" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "12e2aee98f651031d10fd58af76250fa8cab6f28b3e88f03b88b7524c9278549" "f89b15728948b1ea5757a09c3fe56882c2478844062e1033a29ffbd2ed0e0275" "b81bfd85aed18e4341dbf4d461ed42d75ec78820a60ce86730fc17fc949389b2" "365d9553de0e0d658af60cff7b8f891ca185a2d7ba3fc6d29aadba69f5194c7f" "8d737627879eff1bbc7e3ef1e9adc657207d9bf74f9abb6e0e53a6541c5f2e88" "0f0022c8091326c9894b707df2ae58dd51527b0cf7abcb0a310fb1e7bda78cd2" "5310b88333fc64c0cb34a27f42fa55ce371438a55f02ac7a4b93519d148bd03d" "0eef522d30756a80b28333f05c7eed5721f2ba9b3eaaff244ea4c6f6a1b8ac62" "f67652440b66223b66a4d3e9c0ddeddbf4a6560182fa38693bdc4d940ce43a2e" "03003f3ffd8a0151bae8fbd5050891bce553e5b0aef93cb11894db4c953a1925" "4cf3221feff536e2b3385209e9b9dc4c2e0818a69a1cdb4b522756bcdf4e00a4" "8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" "235dc2dd925f492667232ead701c450d5c6fce978d5676e54ef9ca6dd37f6ceb" "bb749a38c5cb7d13b60fa7fc40db7eced3d00aa93654d150b9627cabd2d9b361" "4aee8551b53a43a883cb0b7f3255d6859d766b6c5e14bcb01bed572fcbef4328" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "82d2cac368ccdec2fcc7573f24c3f79654b78bf133096f9b40c20d97ec1d8016" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "d5f17ae86464ef63c46ed4cb322703d91e8ed5e718bf5a7beb69dd63352b26b2" "cf35cc71022eb3744a6e48934e39d817612d64893018c86373d1482efdc2f944" "43c1a8090ed19ab3c0b1490ce412f78f157d69a29828aa977dae941b994b4147" "67e998c3c23fe24ed0fb92b9de75011b92f35d3e89344157ae0d544d50a63a72" "a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" "71ecffba18621354a1be303687f33b84788e13f40141580fa81e7840752d31bf" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" default)))
 '(elfeed-feeds (quote ("https://xkcd.com/rss.xml")))
 '(elfeed-show-entry-author t)
 '(fci-rule-color "#073642")
 '(flycheck-color-mode-line-face-to-color (quote mode-line-buffer-id))
 '(font-latex-math-environments
   (quote
    ("display" "displaymath" "equation" "eqnarray" "gather" "multline" "align" "alignat" "xalignat" "empheq")))
 '(frame-background-mode (quote dark))
 '(fringe-mode 6 nil (fringe))
 '(highlight-changes-colors (quote ("#d33682" "#6c71c4")))
 '(highlight-symbol-colors
   (--map
    (solarized-color-blend it "#002b36" 0.25)
    (quote
     ("#b58900" "#2aa198" "#dc322f" "#6c71c4" "#859900" "#cb4b16" "#268bd2"))))
 '(highlight-symbol-foreground-color "#93a1a1")
 '(highlight-tail-colors
   (quote
    (("#073642" . 0)
     ("#546E00" . 20)
     ("#00736F" . 30)
     ("#00629D" . 50)
     ("#7B6000" . 60)
     ("#8B2C02" . 70)
     ("#93115C" . 85)
     ("#073642" . 100))))
 '(hl-bg-colors
   (quote
    ("#7B6000" "#8B2C02" "#990A1B" "#93115C" "#3F4D91" "#00629D" "#00736F" "#546E00")))
 '(hl-fg-colors
   (quote
    ("#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36")))
 '(hl-paren-colors (quote ("#2aa198" "#b58900" "#268bd2" "#6c71c4" "#859900")))
 '(hl-sexp-background-color "#efebe9")
 '(jdee-db-active-breakpoint-face-colors (cons "#0d0d0d" "#41728e"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#0d0d0d" "#b5bd68"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#0d0d0d" "#5a5b5a"))
 '(linum-format (quote dynamic))
 '(magit-diff-use-overlays nil)
 '(mc/always-run-for-all nil)
 '(nrepl-message-colors
   (quote
    ("#dc322f" "#cb4b16" "#b58900" "#546E00" "#B4C342" "#00629D" "#2aa198" "#d33682" "#6c71c4")))
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
    (alert all-the-icons auctex biblio biblio-core company dash elfeed find-file-in-project flycheck ghub git-commit helm helm-core ht hydra ido-completing-read+ ivy sublimity smooth-scrolling command-log-mode writeroom-mode atom-one-dark-theme dracula-theme yasnippet-snippets helm-swoop oceanic-theme green-phosphor-theme solarized-theme julia-mode espresso-theme cherry-blossom-theme anzu paradox python-mode xkcd screenshot dashboard projectile spacemacs-theme neotree org-ac all-the-icons-dired spaceline-all-the-icons evil doom-themes dad-joke ac-math org-alert dired-quick-sort aggressive-indent emojify dired+ json-mode yaml-mode org2jekyll magit helm-tramp helm-bibtex htmlize xbm-life rainbow-blocks flycheck-cython cython-mode edit-server elpy mu4e-maildirs-extension look-mode undo-tree rainbow-delimiters org-journal multiple-cursors leuven-theme haskell-mode graphene goto-last-change d-mode cyberpunk-theme color-theme-sanityinc-tomorrow color-theme auto-complete-auctex auctex-lua auctex-latexmk 4clojure)))
 '(paradox-github-token t)
 '(pdf-view-midnight-colors (quote ("#DCDCCC" . "#383838")))
 '(pos-tip-background-color "#073642")
 '(pos-tip-foreground-color "#93a1a1")
 '(smartrep-mode-line-active-bg (solarized-color-blend "#859900" "#073642" 0.2))
 '(spaceline-all-the-icons-clock-always-visible t)
 '(spaceline-all-the-icons-flycheck-alternate t)
 '(spaceline-all-the-icons-highlight-file-name t)
 '(spaceline-all-the-icons-icon-set-git-ahead (quote commit))
 '(spaceline-all-the-icons-icon-set-vc-icon-git (quote git-logo))
 '(spaceline-all-the-icons-separator-type (quote arrow))
 '(spaceline-all-the-icons-separators-invert-direction t)
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
 )
;; (load-theme 'dracula-theme)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; python Config ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(package-initialize)
(elpy-enable)

(pyvenv-activate "/home/praharsh/anaconda3")




;; (setq elpy-rpc-python-command "~/py2/bin/./python")
;; (elpy-use-cpython "~/py2/bin/./python")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End Elpy Config ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
(use-package tex-site)
(autoload 'reftex-mode "reftex" "RefTeX Minor Mode" t)
(setq reftex-plug-into-AUCTeX t) ;; why
(autoload 'turn-on-reftex "reftex" "RefTeX Minor Mode" nil)
(autoload 'reftex-citation "reftex-cite" "Make citation" nil)
(autoload 'reftex-index-phrase-mode "reftex-index" "Phrase Mode" t)
(add-hook 'latex-mode-hook 'turn-on-reftex) ; with Emacs latex mode
;; (add-hook 'reftex-load-hook 'imenu-add-menubar-index)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)


;; Latex add environment to math mode
(add-hook 'LaTeX-mode-hook 'add-my-latex-environments)

(defun add-my-latex-environments () 
  (LaTeX-add-environments 
   '("empheq" LaTeX-env-label))) 

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



(global-undo-tree-mode)
;; Helm commands
(global-set-key (kbd "M-x") #'helm-M-x)
(global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
(global-set-key (kbd "C-x C-f") #'helm-find-files)
(global-set-key (kbd "C-M-y") 'helm-show-kill-ring)

(helm-mode 1)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Moving about ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;; ;;;; Helm Swoop


;; helm from https://github.com/emacs-helm/helm
(use-package helm)

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



;; 
;; enable a more powerful jump back function from ace jump mode
;;
(autoload
  'ace-jump-mode-pop-mark
  "ace-jump-mode"
  "Ace jump back:-)"
  t)
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


;;;;; org gcal integration with google-calendar ;;;

(use-package org-alert)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; end org mode ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; making flycheck not treat emacs as a package
(setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))

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
(require 'elfeed)
(require 'elfeed-goodies)
(elfeed-goodies/setup)
;; Load elfeed-org
(require 'elfeed-org)

(elfeed-org)
;; Initialize elfeed-org
;; This hooks up elfeed-org to read the configuration when elfeed
;; is started with =M-x elfeed=

;; Optionally specify a number of files containing elfeed
;; configuration. If not set then the location below is used.
;; Note: The customize interface is also supported.
(setq rmh-elfeed-org-files (list "~/.emacs.d/elfeed.org"))
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


(set-frame-font "-UKWN-SF Mono-normal-normal-extracondensed-*-12-*-*-*-m-0-iso10646-1" nil t)



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

