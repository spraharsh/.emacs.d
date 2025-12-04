;;; init-git.el --- Git configuration -*- lexical-binding: t -*-

;;; Commentary:
;; Magit and git-related configuration.

;;; Code:

;; Magit
(use-package magit
  :bind (("C-x g" . magit-status)
         ("C-x C-g" . magit-status)))

;; Auth sources for git credentials
(setq auth-sources '("~/Dropbox/.authinfo"))

(provide 'init-git)
;;; init-git.el ends here
