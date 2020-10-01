(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(when (fboundp 'menu-bar-mode)
  (menu-bar-mode -1))
(when (fboundp 'toggle-scroll-bar)
  (toggle-scroll-bar -1))
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))

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

(use-package ivy
  :ensure t
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

(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :bind (:map company-active-map
	      ("C-n" . company-select-next)
	      ("C-p" . company-select-previous)))

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  :config
  (setq-default flycheck-disabled-checkers
		'(emacs-lisp-checkdoc)))

(use-package typescript-mode
  :ensure t
  :mode "\\.tsx?\\'")

(use-package rjsx-mode
  :ensure t
  :mode "\\.jsx?\\'")

(defun my/setup-tide-mode ()
  (interactive)
  (setq company-tooltip-align-annotations t)
  (tide-setup)
  (tide-hl-identifier-mode 1))

(use-package tide
  :ensure t
  :after (typescript-mode rjsx-mode company flycheck)
  :hook ((typescript-mode rjsx-mode) . my/setup-tide-mode))

(use-package rainbow-mode
  :diminish
  :hook css-mode)

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
