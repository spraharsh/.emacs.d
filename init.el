;;; init.el --- Emacs configuration loader -*- lexical-binding: t -*-

;;; Commentary:
;; This file loads modular configuration from the config/ directory.
;; Configuration is organized into logical sections for easier maintenance.

;;; Code:

;; Add config directory to load path
(add-to-list 'load-path (expand-file-name "config" user-emacs-directory))

;; Load configuration modules in order
(require 'init-packages)     ; Package archives and load paths
(require 'init-core)         ; Core Emacs settings
(require 'init-ui)           ; Theme, fonts, modeline
(require 'init-completion)   ; Company, Helm, which-key
(require 'init-editing)      ; Multiple cursors, undo-tree, yasnippet
(require 'init-navigation)   ; Helm-swoop, avy, projectile
(require 'init-programming)  ; Tree-sitter, flycheck, smartparens
(require 'init-lsp)          ; LSP mode configuration
(require 'init-python)       ; Python configuration
(require 'init-latex)        ; AUCTeX, helm-bibtex
(require 'init-org)          ; Org-mode configuration
(require 'init-git)          ; Magit configuration
(require 'init-tools)        ; Elfeed, dired, misc tools

;;; Custom variables and faces managed by Emacs Custom system
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
   '((output-pdf "Okular") ((output-dvi style-pstricks) "dvips and gv")
	 (output-dvi "xdvi") (output-pdf "Okular")
	 (output-html "xdg-open")))
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(beacon-color "#ff9da4")
 '(bibtex-dialect 'biblatex)
 '(c-basic-offset 4)
 '(column-number-mode t)
 '(comp-async-report-warnings-errors nil)
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
   '("0f1341c0096825b1e5d8f2ed90996025a0d013a0978677956a9e61408fcd2c77"
	 "2b0fcc7cc9be4c09ec5c75405260a85e41691abb1ee28d29fcd5521e4fca575b"
	 "89d9dc6f4e9a024737fb8840259c5dd0a140fd440f5ed17b596be43a05d62e67"
	 "c5878086e65614424a84ad5c758b07e9edcf4c513e08a1c5b1533f313d1b17f1"
	 "88f7ee5594021c60a4a6a1c275614103de8c1435d6d08cc58882f920e0cec65e"
	 "f5f80dd6588e59cfc3ce2f11568ff8296717a938edd448a947f9823a4e282b66"
	 "7964b513f8a2bb14803e717e0ac0123f100fb92160dcf4a467f530868ebaae3e"
	 "c95813797eb70f520f9245b349ff087600e2bd211a681c7a5602d039c91a6428"
	 "7e068da4ba88162324d9773ec066d93c447c76e9f4ae711ddd0c5d3863489c52"
	 "251ed7ecd97af314cd77b07359a09da12dcd97be35e3ab761d4a92d8d8cf9a71"
	 "683b3fe1689da78a4e64d3ddfce90f2c19eb2d8ab1bab1738a63d8263119c3f4"
	 "5b9a45080feaedc7820894ebbfe4f8251e13b66654ac4394cb416fef9fdca789"
	 "8d8207a39e18e2cc95ebddf62f841442d36fcba01a2a9451773d4ed30b632443"
	 "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a"
	 "2dd4951e967990396142ec54d376cced3f135810b2b69920e77103e0bcedfba9"
	 "a138ec18a6b926ea9d66e61aac28f5ce99739cf38566876dc31e29ec8757f6e2"
	 "00cec71d41047ebabeb310a325c365d5bc4b7fab0a681a2a108d32fb161b4006"
	 "1a1ac598737d0fcdc4dfab3af3d6f46ab2d5048b8e72bc22f50271fd6d393a00"
	 "4c56af497ddf0e30f65a7232a8ee21b3d62a8c332c6b268c81e9ea99b11da0d3"
	 "833ddce3314a4e28411edf3c6efde468f6f2616fc31e17a62587d6a9255f4633"
	 "636b135e4b7c86ac41375da39ade929e2bd6439de8901f53f88fde7dd5ac3561"
	 "51c71bb27bdab69b505d9bf71c99864051b37ac3de531d91fdad1598ad247138"
	 "f6665ce2f7f56c5ed5d91ed5e7f6acb66ce44d0ef4acfaa3a42c7cfe9e9a9013"
	 "fee7287586b17efbfda432f05539b58e86e059e78006ce9237b8732fde991b4c"
	 "1d5e33500bc9548f800f9e248b57d1b2a9ecde79cb40c0b1398dec51ee820daf"
	 "171d1ae90e46978eb9c342be6658d937a83aaa45997b1d7af7657546cae5985b"
	 "cf922a7a5c514fad79c483048257c5d8f242b21987af0db813d3f0b138dfaf53"
	 "4f1d2476c290eaa5d9ab9d13b60f2c0f1c8fa7703596fa91b235db7f99a9441b"
	 "aaa4c36ce00e572784d424554dcc9641c82d1155370770e231e10c649b59a074"
	 "d74c5485d42ca4b7f3092e50db687600d0e16006d8fa335c69cf4f379dbd0eee"
	 "4a8d4375d90a7051115db94ed40e9abb2c0766e80e228ecad60e06b3b397acab"
	 "6c9cbcdfd0e373dc30197c5059f79c25c07035ff5d0cc42aa045614d3919dab4"
	 "a4395e069de3314001de4e139d6a3b1a83dcf9c3fdc68ee7b13eef6c2cba4ae3"
	 "17a58e509bbb8318abf3558c4b7b44273b4f1b555c5e91d00d4785b7b59d6d28"
	 "9e39a8334e0e476157bfdb8e42e1cea43fad02c9ec7c0dbd5498cf02b9adeaf1"
	 "d5a878172795c45441efcd84b20a14f553e7e96366a163f742b95d65a3f55d71"
	 "e72f5955ec6d8585b8ddb2accc2a4cb78d28629483ef3dcfee00ef3745e2292f"
	 "4bca89c1004e24981c840d3a32755bf859a6910c65b829d9441814000cf6c3d0"
	 "b89a4f5916c29a235d0600ad5a0849b1c50fab16c2c518e1d98f0412367e7f97"
	 "990e24b406787568c592db2b853aa65ecc2dcd08146c0d22293259d400174e37"
	 "74ba9ed7161a26bfe04580279b8cad163c00b802f54c574bfa5d924b99daa4b9"
	 "08a27c4cde8fcbb2869d71fdc9fa47ab7e4d31c27d40d59bf05729c4640ce834"
	 "be9645aaa8c11f76a10bcf36aaf83f54f4587ced1b9b679b55639c87404e2499"
	 "e6ff132edb1bfa0645e2ba032c44ce94a3bd3c15e3929cdf6c049802cf059a2a"
	 "28a104f642d09d3e5c62ce3464ea2c143b9130167282ea97ddcc3607b381823f"
	 "f490984d405f1a97418a92f478218b8e4bcc188cf353e5dd5d5acd2f8efd0790"
	 "2d035eb93f92384d11f18ed00930e5cc9964281915689fa035719cab71766a15"
	 "0fffa9669425ff140ff2ae8568c7719705ef33b7a927a0ba7c5e2ffcfac09b75"
	 "1623aa627fecd5877246f48199b8e2856647c99c6acdab506173f9bb8b0a41ac"
	 "76bfa9318742342233d8b0b42e824130b3a50dcc732866ff8e47366aed69de11"
	 "5d09b4ad5649fea40249dd937eaaa8f8a229db1cec9a1a0ef0de3ccf63523014"
	 "2f1518e906a8b60fac943d02ad415f1d8b3933a5a7f75e307e6e9a26ef5bf570"
	 "cf3d5d77679f7daed6a2c863e4f2e30427d5e375b254252127be9359957502ec"
	 "82360e5f96244ce8cc6e765eeebe7788c2c5f3aeb96c1a765629c5c7937c0b5b"
	 "9efb2d10bfb38fe7cd4586afb3e644d082cbcdb7435f3d1e8dd9413cbe5e61fc"
	 "cae81b048b8bccb7308cdcb4a91e085b3c959401e74a0f125e7c5b173b916bf9"
	 "01cf34eca93938925143f402c2e6141f03abb341f27d1c2dba3d50af9357ce70"
	 "54cf3f8314ce89c4d7e20ae52f7ff0739efb458f4326a2ca075bf34bc0b4f499"
	 "6c3b5f4391572c4176908bb30eddc1718344b8eaff50e162e36f271f6de015ca"
	 "7f1d414afda803f3244c6fb4c2c64bea44dac040ed3731ec9d75275b9e831fe5"
	 "711efe8b1233f2cf52f338fd7f15ce11c836d0b6240a18fffffc2cbd5bfe61b0"
	 "c4bdbbd52c8e07112d1bfd00fee22bf0f25e727e95623ecb20c4fa098b74c1bd"
	 "99ea831ca79a916f1bd789de366b639d09811501e8c092c85b2cb7d697777f93"
	 "37144b437478e4c235824f0e94afa740ee2c7d16952e69ac3c5ed4352209eefb"
	 "ae88c445c558b7632fc2d72b7d4b8dfb9427ac06aa82faab8d760fff8b8f243c"
	 "b73a23e836b3122637563ad37ae8c7533121c2ac2c8f7c87b381dd7322714cd0"
	 "0dd2666921bd4c651c7f8a724b3416e95228a13fca1aa27dc0022f4e023bf197"
	 "669e02142a56f63861288cc585bee81643ded48a19e36bfdf02b66d745bcc626"
	 "04589c18c2087cd6f12c01807eed0bdaa63983787025c209b89c779c61c3a4c4"
	 "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58"
	 "a3b6a3708c6692674196266aad1cb19188a6da7b4f961e1369a68f06577afa16"
	 "7a994c16aa550678846e82edc8c9d6a7d39cc6564baaaacc305a3fdc0bd8725f"
	 "f2927d7d87e8207fa9a0a003c0f222d45c948845de162c885bf6ad2a255babfd"
	 "79278310dd6cacf2d2f491063c4ab8b129fee2a498e4c25912ddaa6c3c5b621e"
	 "71e5acf6053215f553036482f3340a5445aee364fb2e292c70d9175fb0cc8af7"
	 "f7216d3573e1bd2a2b47a2331f368b45e7b5182ddbe396d02b964b1ea5c5dc27"
	 "3df5335c36b40e417fec0392532c1b82b79114a05d5ade62cfe3de63a59bc5c6"
	 "1de8de5dddd3c5138e134696180868490c4fc86daf9780895d8fc728449805f3"
	 "fa9fcc03b52009b2bad5b4d8a0db07de1255702c2bef2a0ddba422ae138e44b5"
	 "fa2b58bb98b62c3b8cf3b6f02f058ef7827a8e497125de0254f56e373abee088"
	 "12bacee81d067acf07dec4c867be541a04744a6ac6a39636de25a2c77e9b573c"
	 "1a1cdd9b407ceb299b73e4afd1b63d01bbf2e056ec47a9d95901f4198a0d2428"
	 "24714e2cb4a9d6ec1335de295966906474fdb668429549416ed8636196cb1441"
	 "890a1a44aff08a726439b03c69ff210fe929f0eff846ccb85f78ee0e27c7b2ea"
	 "37768a79b479684b0756dec7c0fc7652082910c37d8863c35b702db3f16000f8"
	 "bf387180109d222aee6bb089db48ed38403a1e330c9ec69fe1f52460a8936b66"
	 "c342ef444e7aca36f4b39a8e2848c4ba793d51c58fdb520b8ed887766ed6d40b"
	 "643b4d181b6afa4306d65db76889d8b987e095ae8f262a4c71dd5669d39c9b09"
	 "c499bf4e774b34e784ef5a104347b81c56220416d56d5fd3fd85df8704260aad"
	 "fc0fe24e7f3d48ac9cf1f87b8657c6d7a5dd203d5dabd2f12f549026b4c67446"
	 "8ce796252a78d1a69e008c39d7b84a9545022b64609caac98dc7980d76ae34e3"
	 "9ef81da35ce99a4c7155db7d46e4f8c20a51860d6879cf082e3ed1c5222c17d3"
	 "dde8c620311ea241c0b490af8e6f570fdd3b941d7bc209e55cd87884eb733b0e"
	 "c83c095dd01cde64b631fb0fe5980587deec3834dc55144a6e78ff91ebc80b19"
	 "e1ef2d5b8091f4953fe17b4ca3dd143d476c106e221d92ded38614266cea3c8b"
	 "2809bcb77ad21312897b541134981282dc455ccd7c14d74cc333b6e549b824f3"
	 "c433c87bd4b64b8ba9890e8ed64597ea0f8eb0396f4c9a9e01bd20a04d15d358"
	 "285d1bf306091644fb49993341e0ad8bafe57130d9981b680c1dbd974475c5c7"
	 "51ec7bfa54adf5fff5d466248ea6431097f5a18224788d0bd7eb1257a4f7b773"
	 "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476"
	 "e074be1c799b509f52870ee596a5977b519f6d269455b84ed998666cf6fc802a"
	 "7f791f743870983b9bb90c8285e1e0ba1bf1ea6e9c9a02c60335899ba20f3c94"
	 "7f6d4aebcc44c264a64e714c3d9d1e903284305fd7e319e7cb73345a9994f5ef"
	 default))
 '(dabbrev-check-all-buffers nil)
 '(display-line-numbers t)
 '(display-line-numbers-width nil)
 '(display-time-day-and-date t)
 '(elfeed-feeds '("https://xkcd.com/rss.xml"))
 '(elfeed-show-entry-author t)
 '(elpy-modules
   '(elpy-module-eldoc elpy-module-pyvenv
					   elpy-module-highlight-indentation
					   elpy-module-yasnippet elpy-module-django
					   elpy-module-autodoc elpy-module-sane-defaults))
 '(flycheck-color-mode-line-face-to-color 'mode-line-buffer-id)
 '(font-latex-math-environments
   '("display" "displaymath" "equation" "eqnarray" "gather" "multline"
	 "align" "alignat" "xalignat" "empheq"))
 '(frame-background-mode 'light)
 '(fringe-mode 6 nil (fringe))
 '(gdb-many-windows t)
 '(helm-completion-style 'emacs)
 '(helm-swoop-speed-or-color t)
 '(helm-swoop-use-line-number-face t)
 '(highlight-changes-colors '("#d3869b" "#8f3f71"))
 '(highlight-indent-guides-method 'character)
 '(highlight-symbol-colors
   '("#eca7d1029ac0" "#d5cfdbc8aed7" "#eaa6bb6792aa" "#e0ddc362b133"
	 "#e32ad9af9d49" "#ee3ac34a94bf" "#c5a0cc76b306"))
 '(highlight-symbol-foreground-color "#665c54")
 '(hl-bg-colors
   '("#e29a3f" "#df6835" "#cf5130" "#f598a7" "#c2608f" "#5b919b"
	 "#82cc73" "#c6c148"))
 '(hl-fg-colors
   '("#fbf1c7" "#fbf1c7" "#fbf1c7" "#fbf1c7" "#fbf1c7" "#fbf1c7"
	 "#fbf1c7" "#fbf1c7"))
 '(hl-paren-background-colors '("#2492db" "#95a5a6" nil))
 '(hl-paren-colors '("#689d6a" "#b57614" "#076678" "#8f3f71" "#98971a"))
 '(hl-sexp-background-color "#efebe9")
 '(hl-todo-keyword-faces
   '(("TODO" . "#dc752f") ("NEXT" . "#dc752f") ("THEM" . "#2d9574")
	 ("PROG" . "#4f97d7") ("OKAY" . "#4f97d7") ("DONT" . "#f2241f")
	 ("FAIL" . "#f2241f") ("DONE" . "#86dc2f") ("NOTE" . "#b1951d")
	 ("KLUDGE" . "#b1951d") ("HACK" . "#b1951d") ("TEMP" . "#b1951d")
	 ("FIXME" . "#dc752f") ("XXX+" . "#dc752f")
	 ("\\?\\?\\?+" . "#dc752f")))
 '(line-number-mode t)
 '(line-spacing 0.2)
 '(linum-format 'dynamic)
 '(lsp-auto-guess-root nil)
 '(lsp-enable-file-watchers nil)
 '(lsp-headerline-breadcrumb-enable nil)
 '(lsp-headerline-breadcrumb-segments '(symbols))
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
   '("#dc322f" "#cb4b16" "#b58900" "#546E00" "#B4C342" "#00629D"
	 "#2aa198" "#d33682" "#6c71c4"))
 '(org-agenda-files '("~/Dropbox/todo.org"))
 '(org-fontify-done-headline t)
 '(org-fontify-quote-and-verse-blocks t)
 '(org-fontify-whole-heading-line t)
 '(org-html-postamble-format
   '(("en"
	  "<p class=\"author\">Author: Praharsh Suryadevara </p>\12<p class=\"date\">Date: %d</p>\12<p class=\"creator\">%c</p>")))
 '(org-journal-dir "~/Dropbox/journal")
 '(org-publish-project-alist
   `
   (("default" :base-directory ,(org2jekyll-input-directory)
	 :base-extension "org" :publishing-directory
	 ,(org2jekyll-output-directory) :publishing-function
	 org-html-publish-to-html :headline-levels 4 :section-numbers nil
	 :with-toc nil :html-head
	 "<link rel=\"stylesheet\" href=\"./css/style.css\" type=\"text/css\"/>"
	 :html-preamble t :recursive t :make-index t :html-extension
	 "html" :body-only t)
	("post" :base-directory ,(org2jekyll-input-directory)
	 :base-extension "org" :publishing-directory
	 ,(org2jekyll-output-directory org2jekyll-jekyll-posts-dir)
	 :publishing-function org-html-publish-to-html :headline-levels 4
	 :section-numbers nil :with-toc nil :html-head
	 "<link rel=\"stylesheet\" href=\"./css/style.css\" type=\"text/css\"/>"
	 :html-preamble t :recursive t :make-index t :html-extension
	 "html" :body-only t)
	("images" :base-directory ,(org2jekyll-input-directory "img")
	 :base-extension "jpg\\|gif\\|png" :publishing-directory
	 ,(org2jekyll-output-directory "img") :publishing-function
	 org-publish-attachment :recursive t)
	("js" :base-directory ,(org2jekyll-input-directory "js")
	 :base-extension "js" :publishing-directory
	 ,(org2jekyll-output-directory "js") :publishing-function
	 org-publish-attachment :recursive t)
	("css" :base-directory ,(org2jekyll-input-directory "css")
	 :base-extension "css\\|el" :publishing-directory
	 ,(org2jekyll-output-directory "css") :publishing-function
	 org-publish-attachment :recursive t)
	("web" :components ("images" "js" "css"))))
 '(org2jekyll-blog-author "ardumont" nil (org2jekyll))
 '(org2jekyll-jekyll-directory (expand-file-name "~/public_html") nil (org2jekyll))
 '(org2jekyll-jekyll-drafts-dir "" nil (org2jekyll))
 '(org2jekyll-jekyll-posts-dir "_posts/" nil (org2jekyll))
 '(org2jekyll-source-directory (expand-file-name "~/website") nil (org2jekyll))
 '(package-selected-packages
   '(company-auctex lsp-grammarly org lsp-julia julia-repl prettier
					company-reftex helm-descbinds ob-ess-julia
					treemacs-all-the-icons persp-projectile circe
					annotate google-this realgud dap-mode
					gitignore-mode gitattributes-mode forge logview
					ccls lsp-jedi goto-line-preview latex-preview-pane
					pdf-tools disable-mouse julia-snail flycheck-julia
					quelpa company-posframe hide-mode-line
					auto-dim-other-buffers poet-theme
					spaceline-all-the-icons company-tabnine
					gmail-message-mode vc-msg spaceline lsp-origami
					vimish-fold yafolding sphinx-mode nix-mode helm-ag
					company-prescient lsp-python-ms lsp-treemacs
					treemacs all-the-icons-dired
					highlight-indent-guides dimmer fira-code-mode
					pretty-mode flatui-theme one-themes ghub+
					doom-modeline kaolin-themes lsp-latex eldoc-box
					which-key helm-lsp company-lsp company-box lsp-ui
					lsp-mode jsonrpc json-rpc flycheck-irony
					company-jedi helm-company company-irony
					company-math langtool irony org-bullets
					helm-projectile cmake-mode cmake-ide ess ein
					jupyter ac-helm helm-rtags flycheck-rtags
					company-rtags ac-rtags ggtags function-args
					origami alert all-the-icons auctex biblio
					biblio-core company dash elfeed
					find-file-in-project flycheck ghub helm helm-core
					ht hydra ido-completing-read+ ivy sublimity
					smooth-scrolling command-log-mode writeroom-mode
					atom-one-dark-theme dracula-theme
					yasnippet-snippets helm-swoop oceanic-theme
					green-phosphor-theme solarized-theme julia-mode
					espresso-theme cherry-blossom-theme anzu paradox
					python-mode xkcd screenshot dashboard projectile
					spacemacs-theme neotree org-ac evil doom-themes
					dad-joke ac-math org-alert dired-quick-sort
					aggressive-indent emojify dired+ json-mode
					yaml-mode org2jekyll magit helm-tramp helm-bibtex
					htmlize xbm-life rainbow-blocks flycheck-cython
					cython-mode edit-server elpy
					mu4e-maildirs-extension look-mode undo-tree
					rainbow-delimiters org-journal multiple-cursors
					leuven-theme haskell-mode graphene
					goto-last-change d-mode cyberpunk-theme
					color-theme-sanityinc-tomorrow color-theme
					auto-complete-auctex auctex-lua auctex-latexmk
					4clojure))
 '(paradox-github-token t)
 '(pos-tip-background-color "#073642")
 '(pos-tip-foreground-color "#93a1a1")
 '(shell-file-name "/usr/bin/bash")
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
 '(term-default-bg-color "#fdf6e3")
 '(term-default-fg-color "#657b83")
 '(tetris-x-colors
   [[229 192 123] [97 175 239] [209 154 102] [224 108 117] [152 195 121]
	[198 120 221] [86 182 194]])
 '(tool-bar-style 'image)
 '(vc-annotate-background-mode nil)
 '(warning-suppress-log-types '((comp) (use-package) (use-package)))
 '(warning-suppress-types '((use-package) (use-package)))
 '(weechat-color-list
   '(unspecified "#002b36" "#073642" "#990A1B" "#dc322f" "#546E00"
				 "#859900" "#7B6000" "#b58900" "#00629D" "#268bd2"
				 "#93115C" "#d33682" "#00736F" "#2aa198" "#839496"
				 "#657b83"))
 '(window-divider-mode nil)
 '(writeroom-width 100)
 '(xterm-color-names
   ["#073642" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198"
	"#eee8d5"])
 '(xterm-color-names-bright
   ["#002b36" "#cb4b16" "#586e75" "#657b83" "#839496" "#6c71c4" "#93a1a1"
	"#fdf6e3"]))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(fixed-pitch ((t (:family "Fira Code" :height 160 :weight demibold))))
 '(lsp-modeline-code-actions-face ((t (:inherit mode-line))) t)
 '(markdown-table-face ((t (:inherit markdown-code-face))))
 '(org-block ((t (:inherit fixed-pitch))))
 '(org-code ((t (:inherit (shadow fixed-pitch)))))
 '(org-default ((t (:weight demibold))))
 '(org-document-info ((t (:foreground "dark orange"))))
 '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
 '(org-document-title ((t (:inherit default :weight bold :foreground "#556b72" :font "SF Pro Display" :height 2.0 :underline nil))))
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
 '(org-property-value ((t (:inherit fixed-pitch))))
 '(org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch)))))
 '(org-table ((t (:inherit fixed-pitch :foreground "#83a598"))))
 '(org-tag ((t (:inherit (shadow fixed-pitch) :weight bold :height 0.8))))
 '(org-verbatim ((t (:inherit (shadow fixed-pitch)))))
 '(preview-reference-face ((t (:inherit default))))
 '(variable-pitch ((t (:family "ETBembo" :height 180 :weight thin)))))

;;; init.el ends here
