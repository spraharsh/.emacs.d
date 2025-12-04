;;; init-ui.el --- UI configuration -*- lexical-binding: t -*-

;;; Commentary:
;; Theme, fonts, modeline, icons, and visual configuration.

;;; Code:

;; Disable annoying UI elements
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)

;; Doom themes
(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-solarized-light t)
  (doom-themes-visual-bell-config)
  (doom-themes-neotree-config)
  (doom-themes-org-config))

;; All the icons
(use-package all-the-icons)

;; Neotree
(use-package neotree)
(global-set-key [f8] 'neotree-toggle)
(setq neo-theme (if (display-graphic-p) 'icons 'arrow))

;; Doom modeline
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))
(display-time)
(display-battery-mode)

;; Dashboard
(use-package dashboard
  :config
  (dashboard-setup-startup-hook))
(setq dashboard-banner-logo-title "Keep your hands dirty || Do calculations ||  Make notes")
(setq dashboard-startup-banner 'logo)
(setq dashboard-items '((recents  . 5)
                        (agenda . 20)))

;; Base font settings
(set-face-attribute 'default nil :family "SF Pro Text" :height 100)
(set-face-attribute 'mode-line nil :font "SF Pro Text" :height 90)

(defun praharsh-prog-fonts ()
  "Set programming mode fonts."
  (face-remap-add-relative 'default :family "SF Mono" :height 100))

(add-hook 'prog-mode-hook #'praharsh-prog-fonts)
(add-hook 'LaTeX-mode-hook #'praharsh-prog-fonts)
(add-hook 'calendar-mode-hook #'praharsh-prog-fonts)
(add-hook 'magit-revision-mode #'praharsh-prog-fonts)

;; Variable/fixed pitch base faces
(custom-theme-set-faces
 'user
 '(variable-pitch ((t (:family "SF Pro Display" :height 100 :weight Normal))))
 '(fixed-pitch ((t (:family "SF Mono" :height 90 :weight Normal)))))

;; Preview scale for LaTeX
(set-default 'preview-scale-function 1.2)

(provide 'init-ui)
;;; init-ui.el ends here
