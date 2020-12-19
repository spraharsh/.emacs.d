;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; MELPA ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'package)
;; (add-to-list 'package-archives
;;              '("melpa" . "https://melpa.org/packages/") t)
;; (add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)

(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
;; (package-initialize) this is probably a bad idea 
;;;; custom elpy files
(add-to-list 'load-path
             "~/.emacs.d/plugins")

(add-to-list 'load-path
             "/usr/local/share/emacs/site-lisp/rtags")


;; (use-package company-tabnine :ensure t)


(use-package graphene)

;; (define-key prog-mode-map (kbd "<return>") 'default-indent-new-line)
(electric-indent-mode 1)
(define-key prog-mode-map (kbd "<return>") 'electric-newline-and-maybe-indent)
;; unset useless key bindings from graphene



(use-package vterm
  :load-path  "/home/praharsh/emacs-libvterm")


;; change garbage collection defaults
(setq gc-cons-threshold 100000000)
(add-hook 'after-init-hook (lambda () (setq gc-cons-threshold 100000000)))

;; process output speed
(setq read-process-output-max (* 1024 1024))


;; (add-to-list 'default-frame-alist
;;              '(font . "Fira Code-12"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End MELPA ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; useful bindings
;; useful bindings
(defun insert-file-name (filename &optional args)
  "Insert name of file FILENAME into buffer after point.
  
  Prefixed with \\[universal-argument], expand the file name to
  its fully canocalized path.  See `expand-file-name'.
  
  Prefixed with \\[negative-argument], use relative path to file
  name from current directory, `default-directory'.  See
  `file-relative-name'.
  
  The default with no prefix is to insert the file name exactly as
  it appears in the minibuffer prompt."
  ;; Based on insert-file in Emacs -- ashawley 20080926
  (interactive "*fInsert file name: \nP")
  (cond ((eq '- args)
         (insert (file-relative-name filename)))
        ((not (null args))
         (insert (expand-file-name filename)))
        (t
         (insert filename))))

(global-set-key "\C-c\C-i" 'insert-file-name)
(global-set-key (kbd "C-c g") 'google-this)



(use-package org2jekyll)
;; (use-package blog)

;;;;;; arxiv-mode


(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                 (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay      0.5
          treemacs-directory-name-transformer    #'identity
          treemacs-display-in-side-window        t
          treemacs-eldoc-display                 t
          treemacs-file-event-delay              5000
          treemacs-file-extension-regex          treemacs-last-period-regex-value
          treemacs-file-follow-delay             0.2
          treemacs-file-name-transformer         #'identity
          treemacs-follow-after-init             t
          treemacs-git-command-pipe              ""
          treemacs-goto-tag-strategy             'refetch-index
          treemacs-indentation                   2
          treemacs-indentation-string            " "
          treemacs-is-never-other-window         nil
          treemacs-max-git-entries               5000
          treemacs-missing-project-action        'ask
          treemacs-move-forward-on-expand        nil
          treemacs-no-png-images                 nil
          treemacs-no-delete-other-windows       t
          treemacs-project-follow-cleanup        nil
          treemacs-persist-file                  (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                      'left
          treemacs-recenter-distance             0.1
          treemacs-recenter-after-file-follow    nil
          treemacs-recenter-after-tag-follow     nil
          treemacs-recenter-after-project-jump   'always
          treemacs-recenter-after-project-expand 'on-distance
          treemacs-show-cursor                   nil
          treemacs-show-hidden-files             t
          treemacs-silent-filewatch              nil
          treemacs-silent-refresh                nil
          treemacs-sorting                       'alphabetic-asc
          treemacs-space-between-root-nodes      t
          treemacs-tag-follow-cleanup            t
          treemacs-tag-follow-delay              1.5
          treemacs-user-mode-line-format         nil
          treemacs-user-header-line-format       nil
          treemacs-width                         35
          treemacs-workspace-switch-cleanup      nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode t)
    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple))))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))



(use-package treemacs-projectile
  :after treemacs projectile
  :ensure t)

(use-package treemacs-icons-dired
  :after treemacs dired
  :ensure t
  :config (treemacs-icons-dired-mode))

(use-package treemacs-magit
  :after treemacs magit
  :ensure t)



(use-package treemacs-persp ;;treemacs-persective if you use perspective.el vs. persp-mode
  :after treemacs persp-mode ;;or perspective vs. persp-mode
  :ensure t
  :config (treemacs-set-scope-type 'Perspectives))





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Graphene  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; To get rid of that annoying error on startup
(setq byte-compile-warnings '(not free-vars ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End Graphene  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;; Exec from shell ;;;;;;;
;; Makes sure that the same configuration exists in shell as well as within emacs
;; This is helpful for programs that rely on packages that have dependencies outside emacs


;; (when (memq window-system '(mac ns x))
;;   (exec-path-from-shell-initialize))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Which key  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Allow C-h to trigger which-key before it is done automatically
(setq which-key-show-early-on-C-h t)
;; make sure which-key doesn't show normally but refreshes quickly after it is
;; triggered.
(setq which-key-idle-delay 0.5)
(setq which-key-idle-secondary-delay 0.05)
(use-package which-key)
(which-key-mode)
(which-key-setup-side-window-bottom)

;;  eldoc box
(use-package eldoc-box)




;; (use-package company-tng)
;; (company-tng-configure-default)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Extras ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package helm-config)
(use-package rainbow-delimiters)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End Extras ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; disables annoying aspects ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)
;; use tab to move out

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
;; (setq company-dabbrev-downcase 0)
(setq company-idle-delay 0)
;; (setq company-show-numbers t)
(add-hook 'after-init-hook 'global-company-mode)
;; flashy company mode
(use-package company-box
  :hook (company-mode . company-box-mode))



;; TODO: Make sure that this works in c++ since petsc is verbose
(setq company-show-numbers 'left)

;; figure out how to bind this 
(defun ora-company-number ()
  "Forward to `company-complete-number'.
taken from https://oremacs.com/2017/12/27/company-numbers/
Unless the number is potentially part of the candidate.
In that case, insert the number."
  (interactive)
  (let* ((k (this-command-keys))
         (re (concat "^" company-prefix k)))
    (if (cl-find-if (lambda (s) (string-match re s))
                    company-candidates)
        (self-insert-command 1)
      (company-complete-number (string-to-number k)))))


;; ;; use numbers 0-9 to select company completion candidates
;; ;; note this can be annoying when typing numbers 
;; ;; since numbers go with C-g n disable in Latex mode
;; (let ((map company-active-map))
;;   (mapc (lambda (x) (define-key map (format "%d" x)
;;                       `(lambda () (interactive) (company-complete-number ,x))))
;;         (number-sequence 0 9)))

;; better completions 
;; (use-package company-prescient
;;   :hook (company-mode . company-prescient-mode))



;; (defun my/python-mode-hook ()
;;   (add-to-list 'company-backends '(company-tabnine company-capf company-dabbrev company-files company-yasnippet)))




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
(setq inhibit-startup-screen t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; get rid of graphene try ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(LaTeX-math-abbrev-prefix "'")
 '(LaTeX-math-list '(("1" "circ" "functions" nil)))
 '(TeX-PDF-mode t)
 '(TeX-command-extra-options "\"-shell-escape\"")
 '(TeX-insert-braces nil)
 '(TeX-source-correlate-method '((dvi . source-specials) (pdf . synctex)))
 '(TeX-source-correlate-mode t)
 '(TeX-view-program-selection
   '((output-pdf "Okular")
     ((output-dvi style-pstricks)
      "dvips and gv")
     (output-dvi "xdvi")
     (output-pdf "Okular")
     (output-html "xdg-open")))
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#FDF6E3" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#556b72"])
 '(beacon-color "#ff9da4")
 '(bibtex-dialect 'biblatex)
 '(c-basic-offset 4)
 '(column-number-mode t)
 '(company-dabbrev-downcase nil)
 '(company-dabbrev-time-limit 0.05)
 '(company-minimum-prefix-length 1)
 '(company-quickhelp-color-background "#D0D0D0")
 '(company-quickhelp-color-foreground "#494B53")
 '(company-tabnine-always-trigger t)
 '(company-tabnine-auto-fallback nil)
 '(company-tabnine-context-radius 3000)
 '(company-tabnine-install-static-binary t)
 '(company-tabnine-wait 0.1)
 '(compilation-message-face 'default)
 '(cua-global-mark-cursor-color "#2aa198")
 '(cua-normal-cursor-color "#839496")
 '(cua-overwrite-cursor-color "#b58900")
 '(cua-read-only-cursor-color "#859900")
 '(cursor-type '(bar . 3))
 '(custom-enabled-themes '(doom-solarized-light))
 '(custom-safe-themes
   '("9e39a8334e0e476157bfdb8e42e1cea43fad02c9ec7c0dbd5498cf02b9adeaf1" "d5a878172795c45441efcd84b20a14f553e7e96366a163f742b95d65a3f55d71" "e72f5955ec6d8585b8ddb2accc2a4cb78d28629483ef3dcfee00ef3745e2292f" "4bca89c1004e24981c840d3a32755bf859a6910c65b829d9441814000cf6c3d0" "b89a4f5916c29a235d0600ad5a0849b1c50fab16c2c518e1d98f0412367e7f97" "990e24b406787568c592db2b853aa65ecc2dcd08146c0d22293259d400174e37" "74ba9ed7161a26bfe04580279b8cad163c00b802f54c574bfa5d924b99daa4b9" "08a27c4cde8fcbb2869d71fdc9fa47ab7e4d31c27d40d59bf05729c4640ce834" "be9645aaa8c11f76a10bcf36aaf83f54f4587ced1b9b679b55639c87404e2499" "e6ff132edb1bfa0645e2ba032c44ce94a3bd3c15e3929cdf6c049802cf059a2a" "28a104f642d09d3e5c62ce3464ea2c143b9130167282ea97ddcc3607b381823f" "f490984d405f1a97418a92f478218b8e4bcc188cf353e5dd5d5acd2f8efd0790" "2d035eb93f92384d11f18ed00930e5cc9964281915689fa035719cab71766a15" "0fffa9669425ff140ff2ae8568c7719705ef33b7a927a0ba7c5e2ffcfac09b75" "1623aa627fecd5877246f48199b8e2856647c99c6acdab506173f9bb8b0a41ac" "76bfa9318742342233d8b0b42e824130b3a50dcc732866ff8e47366aed69de11" "5d09b4ad5649fea40249dd937eaaa8f8a229db1cec9a1a0ef0de3ccf63523014" "2f1518e906a8b60fac943d02ad415f1d8b3933a5a7f75e307e6e9a26ef5bf570" "cf3d5d77679f7daed6a2c863e4f2e30427d5e375b254252127be9359957502ec" "82360e5f96244ce8cc6e765eeebe7788c2c5f3aeb96c1a765629c5c7937c0b5b" "9efb2d10bfb38fe7cd4586afb3e644d082cbcdb7435f3d1e8dd9413cbe5e61fc" "cae81b048b8bccb7308cdcb4a91e085b3c959401e74a0f125e7c5b173b916bf9" "01cf34eca93938925143f402c2e6141f03abb341f27d1c2dba3d50af9357ce70" "54cf3f8314ce89c4d7e20ae52f7ff0739efb458f4326a2ca075bf34bc0b4f499" "6c3b5f4391572c4176908bb30eddc1718344b8eaff50e162e36f271f6de015ca" "7f1d414afda803f3244c6fb4c2c64bea44dac040ed3731ec9d75275b9e831fe5" "711efe8b1233f2cf52f338fd7f15ce11c836d0b6240a18fffffc2cbd5bfe61b0" "c4bdbbd52c8e07112d1bfd00fee22bf0f25e727e95623ecb20c4fa098b74c1bd" "99ea831ca79a916f1bd789de366b639d09811501e8c092c85b2cb7d697777f93" "37144b437478e4c235824f0e94afa740ee2c7d16952e69ac3c5ed4352209eefb" "ae88c445c558b7632fc2d72b7d4b8dfb9427ac06aa82faab8d760fff8b8f243c" "b73a23e836b3122637563ad37ae8c7533121c2ac2c8f7c87b381dd7322714cd0" "0dd2666921bd4c651c7f8a724b3416e95228a13fca1aa27dc0022f4e023bf197" "669e02142a56f63861288cc585bee81643ded48a19e36bfdf02b66d745bcc626" "04589c18c2087cd6f12c01807eed0bdaa63983787025c209b89c779c61c3a4c4" "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "a3b6a3708c6692674196266aad1cb19188a6da7b4f961e1369a68f06577afa16" "7a994c16aa550678846e82edc8c9d6a7d39cc6564baaaacc305a3fdc0bd8725f" "f2927d7d87e8207fa9a0a003c0f222d45c948845de162c885bf6ad2a255babfd" "79278310dd6cacf2d2f491063c4ab8b129fee2a498e4c25912ddaa6c3c5b621e" "71e5acf6053215f553036482f3340a5445aee364fb2e292c70d9175fb0cc8af7" "f7216d3573e1bd2a2b47a2331f368b45e7b5182ddbe396d02b964b1ea5c5dc27" "3df5335c36b40e417fec0392532c1b82b79114a05d5ade62cfe3de63a59bc5c6" "1de8de5dddd3c5138e134696180868490c4fc86daf9780895d8fc728449805f3" "fa9fcc03b52009b2bad5b4d8a0db07de1255702c2bef2a0ddba422ae138e44b5" "fa2b58bb98b62c3b8cf3b6f02f058ef7827a8e497125de0254f56e373abee088" "12bacee81d067acf07dec4c867be541a04744a6ac6a39636de25a2c77e9b573c" "1a1cdd9b407ceb299b73e4afd1b63d01bbf2e056ec47a9d95901f4198a0d2428" "24714e2cb4a9d6ec1335de295966906474fdb668429549416ed8636196cb1441" "890a1a44aff08a726439b03c69ff210fe929f0eff846ccb85f78ee0e27c7b2ea" "37768a79b479684b0756dec7c0fc7652082910c37d8863c35b702db3f16000f8" "bf387180109d222aee6bb089db48ed38403a1e330c9ec69fe1f52460a8936b66" "c342ef444e7aca36f4b39a8e2848c4ba793d51c58fdb520b8ed887766ed6d40b" "643b4d181b6afa4306d65db76889d8b987e095ae8f262a4c71dd5669d39c9b09" "c499bf4e774b34e784ef5a104347b81c56220416d56d5fd3fd85df8704260aad" "fc0fe24e7f3d48ac9cf1f87b8657c6d7a5dd203d5dabd2f12f549026b4c67446" "8ce796252a78d1a69e008c39d7b84a9545022b64609caac98dc7980d76ae34e3" "9ef81da35ce99a4c7155db7d46e4f8c20a51860d6879cf082e3ed1c5222c17d3" "dde8c620311ea241c0b490af8e6f570fdd3b941d7bc209e55cd87884eb733b0e" "c83c095dd01cde64b631fb0fe5980587deec3834dc55144a6e78ff91ebc80b19" "e1ef2d5b8091f4953fe17b4ca3dd143d476c106e221d92ded38614266cea3c8b" "2809bcb77ad21312897b541134981282dc455ccd7c14d74cc333b6e549b824f3" "c433c87bd4b64b8ba9890e8ed64597ea0f8eb0396f4c9a9e01bd20a04d15d358" "285d1bf306091644fb49993341e0ad8bafe57130d9981b680c1dbd974475c5c7" "51ec7bfa54adf5fff5d466248ea6431097f5a18224788d0bd7eb1257a4f7b773" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "e074be1c799b509f52870ee596a5977b519f6d269455b84ed998666cf6fc802a" "7f791f743870983b9bb90c8285e1e0ba1bf1ea6e9c9a02c60335899ba20f3c94" "7f6d4aebcc44c264a64e714c3d9d1e903284305fd7e319e7cb73345a9994f5ef" default))
 '(dabbrev-check-all-buffers nil)
 '(display-line-numbers nil)
 '(display-line-numbers-width 1)
 '(display-time-day-and-date t)
 '(elfeed-feeds '("https://xkcd.com/rss.xml"))
 '(elfeed-show-entry-author t)
 '(elpy-modules
   '(elpy-module-eldoc elpy-module-pyvenv elpy-module-highlight-indentation elpy-module-yasnippet elpy-module-django elpy-module-autodoc elpy-module-sane-defaults))
 '(fci-rule-color "#D6D6D6")
 '(flycheck-color-mode-line-face-to-color 'mode-line-buffer-id)
 '(font-latex-math-environments
   '("display" "displaymath" "equation" "eqnarray" "gather" "multline" "align" "alignat" "xalignat" "empheq"))
 '(frame-background-mode 'light)
 '(fringe-mode 6 nil (fringe))
 '(gdb-many-windows t)
 '(helm-completion-style 'emacs)
 '(helm-swoop-speed-or-color t)
 '(highlight-changes-colors '("#d3869b" "#8f3f71"))
 '(highlight-indent-guides-method 'character)
 '(highlight-symbol-colors
   '("#eca7d1029ac0" "#d5cfdbc8aed7" "#eaa6bb6792aa" "#e0ddc362b133" "#e32ad9af9d49" "#ee3ac34a94bf" "#c5a0cc76b306"))
 '(highlight-symbol-foreground-color "#665c54")
 '(highlight-tail-colors
   '(("#ebdbb2" . 0)
     ("#c6c148" . 20)
     ("#82cc73" . 30)
     ("#5b919b" . 50)
     ("#e29a3f" . 60)
     ("#df6835" . 70)
     ("#f598a7" . 85)
     ("#ebdbb2" . 100)))
 '(hl-bg-colors
   '("#e29a3f" "#df6835" "#cf5130" "#f598a7" "#c2608f" "#5b919b" "#82cc73" "#c6c148"))
 '(hl-fg-colors
   '("#fbf1c7" "#fbf1c7" "#fbf1c7" "#fbf1c7" "#fbf1c7" "#fbf1c7" "#fbf1c7" "#fbf1c7"))
 '(hl-paren-background-colors '("#2492db" "#95a5a6" nil))
 '(hl-paren-colors '("#689d6a" "#b57614" "#076678" "#8f3f71" "#98971a"))
 '(hl-sexp-background-color "#efebe9")
 '(hl-todo-keyword-faces
   '(("TODO" . "#dc752f")
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
     ("\\?\\?\\?+" . "#dc752f")))
 '(jdee-db-active-breakpoint-face-colors (cons "#FFFBF0" "#268bd2"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#FFFBF0" "#859900"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#FFFBF0" "#E1DBCD"))
 '(line-number-mode t)
 '(line-spacing 0.2)
 '(linum-format 'dynamic)
 '(lsp-enable-file-watchers nil)
 '(lsp-julia-default-environment "~/.julia/environments/v1.5")
 '(lsp-pyright-typechecking-mode "off")
 '(lsp-pyright-venv-path "/home/praharsh/anaconda3/envs")
 '(lsp-ui-doc-alignment 'frame)
 '(lsp-ui-doc-border "#586e75")
 '(lsp-ui-doc-delay 100000)
 '(lsp-ui-doc-header nil)
 '(lsp-ui-doc-max-width 80)
 '(lsp-ui-doc-position 'at-point)
 '(lsp-ui-doc-use-childframe t)
 '(lsp-ui-doc-use-webkit nil)
 '(lsp-ui-doc-winum-ignore nil)
 '(lsp-ui-peek-enable t)
 '(lsp-ui-sideline-enable nil)
 '(lsp-ui-sideline-ignore-duplicate t)
 '(lsp-ui-sideline-show-code-actions t)
 '(lsp-ui-sideline-show-diagnostics t)
 '(lsp-ui-sideline-show-hover nil)
 '(lsp-ui-sideline-show-symbol t)
 '(lsp-ui-sideline-update-mode 'point)
 '(magit-diff-use-overlays nil)
 '(mc/always-run-for-all nil)
 '(nrepl-message-colors
   '("#dc322f" "#cb4b16" "#b58900" "#546E00" "#B4C342" "#00629D" "#2aa198" "#d33682" "#6c71c4"))
 '(objed-cursor-color "#dc322f")
 '(org-agenda-files '("~/Dropbox/todo.org"))
 '(org-fontify-done-headline t)
 '(org-fontify-quote-and-verse-blocks t)
 '(org-fontify-whole-heading-line t)
 '(org-html-postamble-format
   '(("en" "<p class=\"author\">Author: Praharsh Suryadevara </p>
<p class=\"date\">Date: %d</p>
<p class=\"creator\">%c</p>")))
 '(org-journal-dir "~/Dropbox/journal/")
 '(org-publish-project-alist
   `(("default" :base-directory ,(org2jekyll-input-directory)
      :base-extension "org" :publishing-directory ,(org2jekyll-output-directory)
      :publishing-function org-html-publish-to-html :headline-levels 4 :section-numbers nil :with-toc nil :html-head "<link rel=\"stylesheet\" href=\"./css/style.css\" type=\"text/css\"/>" :html-preamble t :recursive t :make-index t :html-extension "html" :body-only t)
     ("post" :base-directory ,(org2jekyll-input-directory)
      :base-extension "org" :publishing-directory ,(org2jekyll-output-directory org2jekyll-jekyll-posts-dir)
      :publishing-function org-html-publish-to-html :headline-levels 4 :section-numbers nil :with-toc nil :html-head "<link rel=\"stylesheet\" href=\"./css/style.css\" type=\"text/css\"/>" :html-preamble t :recursive t :make-index t :html-extension "html" :body-only t)
     ("images" :base-directory ,(org2jekyll-input-directory "img")
      :base-extension "jpg\\|gif\\|png" :publishing-directory ,(org2jekyll-output-directory "img")
      :publishing-function org-publish-attachment :recursive t)
     ("js" :base-directory ,(org2jekyll-input-directory "js")
      :base-extension "js" :publishing-directory ,(org2jekyll-output-directory "js")
      :publishing-function org-publish-attachment :recursive t)
     ("css" :base-directory ,(org2jekyll-input-directory "css")
      :base-extension "css\\|el" :publishing-directory ,(org2jekyll-output-directory "css")
      :publishing-function org-publish-attachment :recursive t)
     ("web" :components
      ("images" "js" "css"))))
 '(org2jekyll-blog-author "ardumont" nil (org2jekyll))
 '(org2jekyll-jekyll-directory (expand-file-name "~/public_html") nil (org2jekyll))
 '(org2jekyll-jekyll-drafts-dir "" nil (org2jekyll))
 '(org2jekyll-jekyll-posts-dir "_posts/" nil (org2jekyll))
 '(org2jekyll-source-directory (expand-file-name "~/website") nil (org2jekyll))
 '(package-selected-packages
   '(treemacs-all-the-icons persp-projectile circe annotate google-this realgud dap-mode gitignore-mode gitattributes-mode forge logview ccls lsp-jedi goto-line-preview latex-preview-pane pdf-tools disable-mouse julia-snail flycheck-julia quelpa lsp-julia company-posframe hide-mode-line auto-dim-other-buffers poet-theme spaceline-all-the-icons company-tabnine gmail-message-mode vc-msg spaceline lsp-origami vimish-fold yafolding sphinx-mode nix-mode helm-ag company-prescient lsp-python-ms lsp-treemacs treemacs all-the-icons-dired highlight-indent-guides dimmer fira-code-mode pretty-mode flatui-theme one-themes ghub+ doom-modeline kaolin-themes lsp-latex eldoc-box which-key helm-lsp company-lsp company-box lsp-ui lsp-mode jsonrpc json-rpc flycheck-irony company-jedi helm-company company-irony company-math langtool irony org-bullets helm-projectile cmake-mode cmake-ide ess ein jupyter ac-helm helm-rtags flycheck-rtags company-rtags ac-rtags ggtags function-args origami alert all-the-icons auctex biblio biblio-core company dash elfeed find-file-in-project flycheck ghub git-commit helm helm-core ht hydra ido-completing-read+ ivy sublimity smooth-scrolling command-log-mode writeroom-mode atom-one-dark-theme dracula-theme yasnippet-snippets helm-swoop oceanic-theme green-phosphor-theme solarized-theme julia-mode espresso-theme cherry-blossom-theme anzu paradox python-mode xkcd screenshot dashboard projectile spacemacs-theme neotree org-ac evil doom-themes dad-joke ac-math org-alert dired-quick-sort aggressive-indent emojify dired+ json-mode yaml-mode org2jekyll magit helm-tramp helm-bibtex htmlize xbm-life rainbow-blocks flycheck-cython cython-mode edit-server elpy mu4e-maildirs-extension look-mode undo-tree rainbow-delimiters org-journal multiple-cursors leuven-theme haskell-mode graphene goto-last-change d-mode cyberpunk-theme color-theme-sanityinc-tomorrow color-theme auto-complete-auctex auctex-lua auctex-latexmk 4clojure))
 '(paradox-github-token t)
 '(pdf-view-midnight-colors (cons "#556b72" "#FDF6E3"))
 '(pos-tip-background-color "#073642")
 '(pos-tip-foreground-color "#93a1a1")
 '(rustic-ansi-faces
   ["#FDF6E3" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#556b72"])
 '(size-indication-mode t)
 '(smartrep-mode-line-active-bg (solarized-color-blend "#859900" "#073642" 0.2))
 '(sml/active-background-color "#34495e")
 '(sml/active-foreground-color "#ecf0f1")
 '(sml/inactive-background-color "#dfe4ea")
 '(sml/inactive-foreground-color "#34495e")
 '(spaceline-all-the-icons-clock-always-visible t)
 '(spaceline-all-the-icons-flycheck-alternate t)
 '(spaceline-all-the-icons-highlight-file-name t)
 '(spaceline-all-the-icons-icon-set-git-ahead 'commit)
 '(spaceline-all-the-icons-icon-set-vc-icon-git 'git-logo)
 '(spaceline-all-the-icons-separator-type 'arrow)
 '(spaceline-all-the-icons-separators-invert-direction t)
 '(split-height-threshold nil)
 '(split-width-threshold 0)
 '(tab-width 4)
 '(term-default-bg-color "#002b36")
 '(term-default-fg-color "#839496")
 '(tetris-x-colors
   [[229 192 123]
    [97 175 239]
    [209 154 102]
    [224 108 117]
    [152 195 121]
    [198 120 221]
    [86 182 194]])
 '(tool-bar-style 'image)
 '(vc-annotate-background "#FDF6E3")
 '(vc-annotate-background-mode nil)
 '(vc-annotate-color-map
   (list
    (cons 20 "#859900")
    (cons 40 "#959300")
    (cons 60 "#a58e00")
    (cons 80 "#b58900")
    (cons 100 "#bc7407")
    (cons 120 "#c35f0e")
    (cons 140 "#cb4b16")
    (cons 160 "#cd4439")
    (cons 180 "#d03d5d")
    (cons 200 "#d33682")
    (cons 220 "#d63466")
    (cons 240 "#d9334a")
    (cons 260 "#dc322f")
    (cons 280 "#dd5c56")
    (cons 300 "#de867e")
    (cons 320 "#dfb0a5")
    (cons 340 "#D6D6D6")
    (cons 360 "#D6D6D6")))
 '(vc-annotate-very-old-color nil)
 '(weechat-color-list
   '(unspecified "#002b36" "#073642" "#990A1B" "#dc322f" "#546E00" "#859900" "#7B6000" "#b58900" "#00629D" "#268bd2" "#93115C" "#d33682" "#00736F" "#2aa198" "#839496" "#657b83"))
 '(window-divider-mode nil)
 '(writeroom-width 100)
 '(xterm-color-names
   ["#073642" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#eee8d5"])
 '(xterm-color-names-bright
   ["#002b36" "#cb4b16" "#586e75" "#657b83" "#839496" "#6c71c4" "#93a1a1" "#fdf6e3"]))


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(fixed-pitch ((t (:family "Fira Code" :height 160 :weight demibold))))
 '(lsp-modeline-code-actions-face ((t (:inherit mode-line))))
 '(markdown-table-face ((t (:inherit markdown-code-face))))
 '(org-block ((t (:inherit fixed-pitch))))
 '(org-code ((t (:inherit (shadow fixed-pitch)))))
 '(org-default ((t (:weight demibold))))
 '(org-document-info ((t (:foreground "dark orange"))))
 '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
 '(org-document-title ((t (:inherit default :weight bold :foreground "#556b72" :family "Sans Serif" :height 2.0 :underline nil))))
 '(org-indent ((t (:inherit (org-hide fixed-pitch)))))
 '(org-level-1 ((t (:inherit default :weight bold :foreground "#556b72" :family "Sans Serif" :height 1.75))))
 '(org-level-2 ((t (:inherit default :weight bold :foreground "#556b72" :family "Sans Serif" :height 1.5))))
 '(org-level-3 ((t (:inherit default :weight bold :foreground "#556b72" :family "Sans Serif" :height 1.25))))
 '(org-level-4 ((t (:inherit default :weight bold :foreground "#556b72" :family "Sans Serif" :height 1.1))))
 '(org-level-5 ((t (:inherit default :weight bold :foreground "#556b72" :family "Sans Serif"))))
 '(org-level-6 ((t (:inherit default :weight bold :foreground "#556b72" :family "Sans Serif"))))
 '(org-level-7 ((t (:inherit default :weight bold :foreground "#556b72" :family "Sans Serif"))))
 '(org-level-8 ((t (:inherit default :weight bold :foreground "#556b72" :family "Sans Serif"))))
 '(org-link ((t (:foreground "royal blue" :underline t))))
 '(org-meta-line ((t (:inherit (font-lock-comment-face fixed-pitch)))))
 '(org-property-value ((t (:inherit fixed-pitch))) t)
 '(org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch)))))
 '(org-table ((t (:inherit fixed-pitch :foreground "#83a598"))))
 '(org-tag ((t (:inherit (shadow fixed-pitch) :weight bold :height 0.8))))
 '(org-verbatim ((t (:inherit (shadow fixed-pitch)))))
 '(preview-reference-face ((t (:inherit default))))
 '(variable-pitch ((t (:family "ETBembo" :height 180 :weight thin)))))





(use-package preview
  :commands LaTeX-preview-setup
  :init
  (setq-default preview-scale 2.0
                preview-scale-function '(lambda () (* (/ 10.0 (preview-document-pt)) preview-scale))))

;; (load-theme 'dracula-theme)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; python Config ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (package-initialize)


(pyvenv-activate "/home/praharsh/anaconda3/envs/changebranch3")
;; (setq elpy-rpc-python-command "/home/praharsh/anaconda3/envs/changebranch3/bin/python")
;; (elpy-enable)
;; not fast enough unfortunately
;; (add-hook 'python-mode-hook
;;           (lambda ()
;;             (set (make-local-variable 'company-backends) '((company-tabnine)))))
(add-hook 'python-mode-hook
          (lambda ()
            (set (make-local-variable 'company-backends) '((company-capf :with company-yasnippet)))))

;; (setq flycheck-python-flake8-executable "flake8")



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Jupyter Config ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq ein:output-area-inlined-images t)

;; (setq elpy-rpc-python-command "~/py2/bin/./python")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Language Server Protocol config ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
(setq lsp-keymap-prefix "C-c l")


(use-package lsp-mode
  :hook (((c-mode c++-mode python-mode) . lsp)
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
  :config
  (setq lsp-clients-clangd-executable "/usr/bin/clangd-11")
  (setq lsp-pyls-server-command "/home/praharsh/anaconda3/envs/extras/bin/pyls")
  (setq lsp-clients-clangd-args '("-j=6" "-background-index" "-log=error"))
  )








;; (defun lsp-set-cfg ()
;;   (let ((lsp-cfg `(:pyls (:configurationSources ("flake8")))))
;;     ;; TODO: check lsp--cur-workspace here to decide per server / project
;;     (lsp--set-configuration lsp-cfg)))

;; (add-hook 'lsp-after-initialize-hook 'lsp-set-cfg)

(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp)))
  )  ; or lsp-deferred
;; (use-package lsp-jedi
;;   :ensure t
;;   :config
;;   (with-eval-after-load "lsp-mode"
;;     (add-to-list 'lsp-disabled-clients 'pyls)
;;     (add-to-list 'lsp-enabled-clients 'jedi)))

;; the julia lsp package currently sucks
(use-package lsp-julia
  :ensure t
  :hook (julia-mode . (lambda ()
                        (require 'lsp-julia)
                        (lsp)))
  )




(setq lsp-latex-texlab-executable "texlab")
(use-package lsp-latex)
;; Important to make backend capf only in situations without TeX
;; (setq lsp-completion-provider :none)

;; optionally
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
  (setq lsp-ui-sideline-update-mode 'line)
  )


;; Change the font for LSP UI doc 
(add-hook 'lsp-ui-doc-frame-hook
          (lambda (frame _w)
            (set-face-attribute 'default frame :font "SF Pro Text" :height 130)))


;; change what enter does in lsp ui peek mode
(add-hook 'lsp-ui-peek-mode-hook
          (lambda()
            (local-unset-key (kbd "<return>"))
            (define-key lsp-ui-peek-mode-map (kbd "<S-return>") 'lsp-ui-peek--goto-xref)
            ))









(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)




;; (define-key lsp-ui-mode-map (kbd "M-.") 'lsp-ui-peek-find-definitions)  
;; (define-key lsp-ui-mode-map (kbd "M-?") 'lsp-ui-peek-find-references)
;; (define-key lsp-ui-mode-map (kbd "C-c l .") 'lsp-ui-peek-find-definitions)
;; (define-key lsp-ui-mode-map (kbd "C-c l ?") 'lsp-ui-peek-find-references)
;; (define-key lsp-ui-mode-map (kbd "C-c l r") 'lsp-rename)
;; (define-key lsp-ui-mode-map (kbd "C-c l x") 'lsp-restart-workspace)
;; (define-key lsp-ui-mode-map (kbd "C-c l w") 'lsp-ui-peek-find-workspace-symbol)
;; (define-key lsp-ui-mode-map (kbd "C-c l i") 'lsp-ui-peek-find-implementation)
;; (define-key lsp-ui-mode-map (kbd "C-c l d") 'lsp-describe-thing-at-point)
;; (define-key lsp-ui-mode-map (kbd "C-c l e") 'lsp-execute-code-action)
;; (define-key lsp-ui-mode-map (kbd "C-c l l") 'lsp-ui-imenu)



;; if you are helm user
(use-package helm-lsp
  :commands helm-lsp-workspace-symbol
  :bind (:map lsp-mode-map
              ("C-c f" . helm-lsp-workspace-symbol)))



;; (use-package company-lsp)
;; (setq company-backends
;;       '((company-files          ; files & directory
;;          company-keywords       ; keywords
;;          company-capf
;;          company-yasnippet
;;          company-abbrev
;;          company-dabbrev
;;          )
;;         ))
;; (setq company-backends
;;       '((company-tabnine
;;          )
;;         ))
;; (setq company-dabbrev-downcase 0)

(add-hook 'LaTeX-mode-hook
          (lambda ()
            (set (make-local-variable 'company-backends) '(
                                                           (company-yasnippet
                                                            company-dabbrev
                                                            company-math-symbols-latex
                                                            )
                                                           ))))



;; (add-hook 'c++-mode-hook
;;           (lambda ()
;;             (set (make-local-variable 'company-backends) '(company-capf company-yasnippet))))
;; (add-hook 'c++-mode-hook
;;           (lambda ()
;;             (set (make-local-variable 'company-backends) '((company-capf :with company-yasnippet)))
;;             )
;;           )




(use-package lsp-treemacs)

(lsp-treemacs-sync-mode 1)
(define-key lsp-mode-map (kbd "C-c s") 'lsp-treemacs-symbols)


;; add debug fatures
(require 'dap-python)
(require 'dap-cpptools)



(c-set-offset 'innamespace 0)




(use-package langtool
  :defer 1
  :config
  ;; install with `brew install languagetool`
  (setq langtool-language-tool-server-jar "/home/praharsh/Dropbox/LanguageTool-5.0/languagetool-server.jar")
  (setq langtool-java-bin "/usr/bin/java")
  (setq langtool-default-language "en-US"))







;; origami
;; TODO:: Set up origami
;; (req-package origami)

;; mcpele pele stuff

;; (setenv "PYTHONPATH"
;;         (concat
;;          "/home/praharsh/Dropbox/stefano/mcpele" ":"
;;          "/home/praharsh/Dropbox/stefano/pele" 
;;          )
;;         )



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; git config ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package magit
  :bind (("C-x g" . magit-status)
         ("C-x C-g" . magit-status)))
;; access token locations
(setq auth-sources '("~/Dropbox/.authinfo"))





 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (add-to-list 'load-path
;;              "~/.emacs.d/plugins/yasnippet") 

(use-package yasnippet)
(yas-global-mode 1)
(define-key yas-minor-mode-map (kbd "<C-tab>") 'yas-expand)
(define-key yas-keymap [tab] 'yas-next-field-or-maybe-expand)


(use-package auctex
  :defer t
  :ensure t)
;;;;;;;;;;;;;;;;;;;;;;;;; Latex Config

;; (add-to-list 'company-backends 'company-math-symbols-unicode)



(use-package doom-themes
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-solarized-light t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))


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

(setq org-clock-mode-line-total 'current)

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

(use-package helm-swoop)

;; Change the keybinds to whatever you like :)
(global-set-key (kbd "M-i") 'helm-swoop)
(global-set-key (kbd "M-I") 'helm-swoop-back-to-last-point)
(global-set-key (kbd "C-c M-i") 'helm-multi-swoop)
(global-set-key (kbd "C-x M-i") 'helm-multi-swoop-all)
(setq helm-swoop-speed-or-color t)
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
;; (add-to-list 'load-path "/full/path/where/ace-jump-mode.el/in/")
;; (autoload
;;   'ace-jump-mode
;;   "ace-jump-mode"
;;   "Emacs quick move minor mode"
;;   t)
;; you can select the key you prefer to
(define-key global-map (kbd "<print>") 'avy-goto-word-1)
(define-key global-map (kbd "<kp-0>") 'avy-goto-word-1)
(define-key global-map (kbd "C-c j") 'avy-goto-word-1)
;; use C-u C-Space to go back to previous cursor position
(global-set-key [remap goto-line] 'goto-line-preview)




;; eaf
(use-package eaf
  :load-path "~/.emacs.d/emacs-application-framework" ; Set to "/usr/share/emacs/site-lisp/eaf" if installed from AUR
  :custom
  (eaf-find-alternate-file-in-dired t)
  :config
  (eaf-bind-key scroll_up "C-n" eaf-pdf-viewer-keybinding)
  (eaf-bind-key scroll_down "C-p" eaf-pdf-viewer-keybinding)
  (eaf-bind-key take_photo "p" eaf-camera-keybinding))


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

(setq projectile-sort-order 'recentf)
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
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((latex . t) (python . t) (haskell . t) (emacs-lisp . t)))

(setq org-babel-python-command "~/miniconda2/envs/basemacs/bin/./python")
(add-hook 'after-init-hook 'org-agenda-list)

;; yasnippet cofiguration
;; (add-hook 'org-mode-hook
;;           (lambda ()
;;             (setq-local yas/trigger-key [tab])
;;             (define-key yas/keymap [tab] 'yas-next-field-or-maybe-expand)))
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
;; '(flycheck-idle-change-delay 1) ;; Set delay based on what suits you the best


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
;; (setq rmh-elfeed-org-files (list "~/.emacs./elfeed.org"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; add emojis :)
(add-hook 'after-init-hook #'global-emojify-mode)
;; works :P this is awesome.


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
;; (add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
;;;; neotree
(use-package neotree)
(global-set-key [f8] 'neotree-toggle)
(setq neo-theme (if (display-graphic-p) 'icons 'arrow))

;; (use-package spaceline-config)
;; (spaceline-all-the-icons-theme)
;; (spaceline-all-the-icons--setup-package-updates) ;; Enable package update indicator
;; (spaceline-all-the-icons--setup-git-ahead)       ;; Enable # of commits ahead of upstream in git
;; (spaceline-all-the-icons--setup-paradox)         ;; Enable Paradox mode line
;; (spaceline-all-the-icons--setup-neotree)
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))
(display-time)
(display-battery-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (use-package doom-modeline
;;   :ensure t
;;   :init (doom-modeline-mode 1))

;; Paradox
(use-package paradox)
(paradox-enable)

;; anzu search
(use-package anzu)
(global-anzu-mode +1)


;; kbd macros
(fset 'open-and-goto-new-buffer
      (kmacro-lambda-form [?\C-x ?3 ?\C-x ?o] 0 "%d"))








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
(setq dashboard-startup-banner 'logo)

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





(define-key company-active-map (kbd "C-s") 'company-complete-common-or-cycle)
(define-key company-active-map (kbd "C-r") 'company-select-previous-or-abort)



;; use ligatures when they start working
;; (use-package fira-code-mode
;;   :custom (fira-code-mode-disabled-ligatures '("[]" "#{" "#(" "#_" "#_(" "x" "::")) ;; List of ligatures to turn off
;;   :hook prog-mode) ;; Enables fira-code-mode automatically for programming major modes



;; UI changes
;; ;; if you want font change ever
(set-face-attribute 'default nil :family "SF Pro Text" :height 100)
(set-face-attribute 'mode-line nil :font "SF Pro Text" :height 90)


(defun praharsh-prog-fonts ()
  (face-remap-add-relative 'default :family "SF Mono" :height 100))

(add-hook 'prog-mode-hook #'praharsh-prog-fonts)
(add-hook 'LaTeX-mode-hook #'praharsh-prog-fonts)
(add-hook 'calendar-mode-hook #'praharsh-prog-fonts)
(add-hook 'org-mode-hook
          (lambda ()
            (variable-pitch-mode 1)))




(setq org-hide-emphasis-markers t)

(font-lock-add-keywords 'org-mode
                        '(("^ *\\([-]\\) "
                           (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))
(use-package org-bullets
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

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
 '(variable-pitch ((t (:family "SF Pro Display" :height 100 :weight Normal))))
 '(fixed-pitch ((t ( :family "SF Mono" :height 90 :weight Normal)))))

(add-hook 'org-mode-hook 'variable-pitch-mode)
;; (add-hook 'LaTeX-mode-hook 'variable-pitch-mode)

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
 '(org-verbatim ((t (:inherit (shadow fixed-pitch)))))
 '(org-default ((t (:weight demibold))))
 )


;; (with-eval-after-load 'font-latex
;;   (set-face-attribute 'font-latex-math-face nil :family "SF Mono" :height 120))


;; provide init ends here
(setq gc-cons-threshold 100000000)

