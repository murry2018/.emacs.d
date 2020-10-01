(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;;;; Turn off menu-bar, scroll-bar, tool-bar
(when (fboundp 'menu-bar-mode)
  (menu-bar-mode -1))
(when (fboundp 'toggle-scroll-bar)
  (toggle-scroll-bar -1))
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))

;;;; Required packages
;;; Resources
;; Github(use-package): https://github.com/jwiegley/use-package
;; Manual(use-package): https://jwiegley.github.io/use-package/
;; Github(diminish.el): https://github.com/myrjola/diminish.el
;;; Explanation
;; use-package :: declarative package managing library
;; diminish.el :: adjust text displayed in minor-modes
(unless (and (package-installed-p 'use-package)
	     (package-installed-p 'diminish))
  (package-refresh-contents)
  (unless (package-installed-p 'use-package)
    (package-install 'use-package))
  (unless (package-installed-p 'diminish)
    (package-install 'diminish)))

(eval-when-compile
  (require 'use-package))
(require 'bind-key)
(require 'diminish)

;;;; Ivy + Counsel + Swiper
;;; Resources
;; Github: https://github.com/abo-abo/swiper
;; Manual: https://oremacs.com/swiper/
(use-package ivy
  :ensure t
  ;; Using defer 0.1 avoids waiting a while to launch GNU Emacs before
  ;; you can interact with it.
  ;; from - https://www.reddit.com/r/emacs/comments/910pga/tip_how_to_use_ivy_and_its_utilities_in_your/
  :defer 0.1
  :diminish
  :bind ("C-x C-b" . ivy-switch-buffer-other-window)
  :custom
  (ivy-count-format "(%d/%d) ")
  (ivy-use-virtual-buffers t)
  :config (ivy-mode))

(use-package counsel
  :ensure t
  :after ivy
  :diminish
  :config (counsel-mode))

(use-package swiper
  :ensure t
  :after ivy
  :diminish
  :bind ("C-s" . swiper))

;;;; Company mode
;;; Resources
;; Website: https://company-mode.github.io/
;;; Explanation
;; Auto completion frontend framework
(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :bind (:map company-active-map
	      ("C-n" . company-select-next)
	      ("C-p" . company-select-previous)))

;;;; Flycheck
;;; Resources
;; Website: https://www.flycheck.org/en/latest/
;;; Explanation
;; On-the-fly syntax check library
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  :config
  (setq-default flycheck-disabled-checkers
		'(emacs-lisp-checkdoc)))

;;;; Typescript, RJSX mode
;;; Resources
;; Github(RJSX): https://github.com/felipeochoa/rjsx-mode
;;; Explanation
;; Editing, syntax-highlighting major modes for js and ts
(use-package typescript-mode
  :ensure t
  :mode "\\.tsx?\\'")

(use-package rjsx-mode
  :ensure t
  :mode "\\.jsx?\\'")

;;;; TIDE
;;; Resources
;; Github: https://github.com/ananthakumaran/tide
;;; Explanation
;; Typescript/javascript LSP
;; It works with company and flycheck.
;;; Prerequisites
;; - [Mandatory] node.js >= 0.12.0
;; - [Mandatory] tsconfig.json or jsconfig.json in the
;;   project root directory.
(defun my/setup-tide-mode ()
  (interactive)
  (setq company-tooltip-align-annotations t)
  (tide-setup)
  (tide-hl-identifier-mode 1))

;; rjsx-mode-hook isn't automatically loaded.
;; rjsx-mode-hook is used in tide config below.
(require 'rjsx-mode)

(use-package tide
  :ensure t
  :after (typescript-mode rjsx-mode company flycheck)
  :hook ((typescript-mode rjsx-mode) . #'my/setup-tide-mode))

;;;; Rainbow mode
;;; Resources
;; Website: https://elpa.gnu.org/packages/rainbow-mode.html
;;; Explanation
;; Colorize css color code.
(use-package rainbow-mode
  :diminish
  :hook css-mode)

;;;; ELPY
;;; Rsources
;; Github: https://elpa.gnu.org/packages/rainbow-mode.html
;; Manual: https://elpy.readthedocs.io/en/latest/index.html
;;; Explanation
;; All I need for python scripting.
(use-package elpy
  :ensure t
  :init (elpy-enable))

;;;; Markdown
;;; Resources
;; Website: https://jblevins.org/projects/markdown-mode/
;;; Explanation
;; Editing, syntax-highlighting markdown
;;; Prerequisites
;; - [Not mandatory] Markdown processor e.g. Markdown.pl,
;;   MultiMarkdown, Pandoc
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
	 ("\\.md\\'" . markdown-mode)
	 ("\\.markdown\\'" . markdown-mode)))

;;;; Edit-indirect
;;; Resources
;; MELPA: https://melpa.org/#/edit-indirect
;;; Explanation
;; Edit regions in separate buffers, like 'org-edit-src-code'
(use-package edit-indirect
  :ensure t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(tango-dark))
 '(package-selected-packages '(use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
