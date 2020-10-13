(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

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

;;;; Web, RJSX mode
;;; Resources
;; Website(Web-mode): http://web-mode.org/
;; Github(Web-mode): https://github.com/fxbois/web-mode
;; Github(RJSX): https://github.com/felipeochoa/rjsx-mode
;;; Explanation
;; Editing, syntax-highlighting major modes for js and ts
(use-package web-mode
  :ensure t
  :mode "\\.tsx?\\'"
  :custom
  (web-mode-markup-indent-offset 2)
  (web-mode-code-indent-offset 2)
  (web-mode-attr-indent-offset 2))

(use-package rjsx-mode
  :ensure t
  :mode "\\.jsx?\\'"
  :custom
  (js-indent-level 2))

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

(require 'rjsx-mode) ;; rjsx-mode-hook
(require 'tide) ;; jsx-tide, javascript-tide

(use-package tide
  :ensure t
  :after (web-mode rjsx-mode company flycheck)
  :hook ((web-mode rjsx-mode) . #'my/setup-tide-mode)
  :config
  ;; js, jsx support
  (flycheck-add-mode 'javascript-eslint 'rjsx-mode)
  (flycheck-add-next-checker 'javascript-eslint 'jsx-tide 'append))

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
;; Run emacs in virtualenv, and launch `M-x elpy-config'.
;;; Prerequisites
;; - [Mandatory] virtualenv, venv or pipenv
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

;;;; YAML-MODE
;;; Resources
;; Github: https://github.com/yoshiki/yaml-mode
;;; Explanation
;; Editing and Syntax-highlighting .yml file
(use-package yaml-mode
  :ensure t
  :defer t
  :mode "\\.yml\\'"
  :bind ("C-m" . newline-and-indent))

;;;; Dockerfile-mode
;;; Reosources
;; Github: https://github.com/spotify/dockerfile-mode
;;; Explanation
;; Editing and syntax-highlighting Dockerfile
(use-package dockerfile-mode
  :ensure t
  :mode ("Dockerfile" "Dockerfile-dev" "Dockerfile.dev"))

;;;; LSP-mode
;;; Resources
;; Website: https://emacs-lsp.github.io/lsp-mode/
(use-package lsp-mode
  :ensure t
  :hook
  ((haskell-mode . lsp)
   (haskell-literate-mode . lsp))
  :custom
  ;; use capf backends instead of company-lsp
  (lsp-completion-provider :capf)
  :commands lsp)

;;;; LSP-haskell
;;; Resources
;; Github: https://github.com/emacs-lsp/lsp-haskell
;;; Dependency
;; 1.
;; haskell-language-server: https://github.com/haskell/haskell-language-server
;; Building from source takes so much time. Consider pre-built binary.
;; 2.
;; GHC executable on PATH
;; stack or cabal executable on PATH
;; 3.
;; hie.yaml on project root
;; hie.yaml basic setting
;; ```
;;   cradle:
;;     stack:
;; ```
(use-package lsp-haskell
  :ensure t
  :after lsp-mode
  :custom
  (haskell-process-type 'stack-ghci))
  

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(tango-dark))
 '(package-selected-packages '(lsp-haskell company-lsp lsp-mode use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
