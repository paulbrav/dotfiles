;; Stanford CS107 Enhanced Emacs Configuration
;; Based on https://web.stanford.edu/class/archive/cs/cs107/cs107.1256/resources/emacs_advanced

;; Package Management
(require 'package)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
(package-initialize)

;; Ensure packages are installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; Whitespace Mode Configuration
(require 'whitespace)
(setq whitespace-style '(face empty tabs lines-tail trailing))
(setq whitespace-line-column 80)
(add-hook 'prog-mode-hook 'whitespace-mode)

;; Auto-Fill Mode for Comments
(add-hook 'prog-mode-hook 'auto-fill-mode)
(setq comment-auto-fill-only-comments t)

;; Electric Pair Mode (Auto-close brackets)
(add-hook 'prog-mode-hook 'electric-pair-mode)

;; Show matching parentheses
(show-paren-mode 1)

;; Flycheck for real-time syntax checking
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  :config
  (add-hook 'c-mode-common-hook
            (lambda () (setq flycheck-gcc-language-standard "c++11"))))

;; Company mode for completion
(use-package company
  :ensure t
  :init (global-company-mode)
  :config
  (setq company-idle-delay 0.1
        company-minimum-prefix-length 1))

;; Modern C/C++ support
(use-package modern-cpp-font-lock
  :ensure t
  :config
  (modern-c++-font-lock-global-mode t))

;; Theme
(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-one t))

;; Better mode line
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

;; Git integration
(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

;; Project management
(use-package projectile
  :ensure t
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("C-c p" . projectile-command-map)))

;; Window management
(winner-mode 1)

;; Line numbers
(global-display-line-numbers-mode)

;; Custom key bindings
(global-set-key (kbd "C-x C-b") 'ibuffer)  ; Better buffer menu
(global-set-key (kbd "M-/") 'hippie-expand) ; Better completion

;; Backup files settings
(setq backup-directory-alist `(("." . "~/.emacs.d/backups")))
(setq auto-save-file-name-transforms
      `((".*" "~/.emacs.d/auto-save-list/" t)))

;; General settings
(setq-default
 inhibit-startup-screen t
 initial-scratch-message nil
 sentence-end-double-space nil
 default-fill-column 80
 indent-tabs-mode nil
 tab-width 4
 c-basic-offset 4)

;; UTF-8 everywhere
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8) 