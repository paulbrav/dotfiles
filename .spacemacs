;; -*- mode: emacs-lisp; lexical-binding: t -*-

(defun dotspacemacs/layers ()
  (setq-default
   dotspacemacs-distribution 'spacemacs
   dotspacemacs-enable-lazy-installation 'unused
   dotspacemacs-ask-for-lazy-installation t

   ;; List of configuration layers
   dotspacemacs-configuration-layers
   '(
     ;; Core layers
     auto-completion
     better-defaults
     git
     syntax-checking
     version-control
     
     ;; Languages
     (c-c++ :variables
            c-c++-enable-clang-support t
            c-c++-default-mode-for-headers 'c++-mode)
     emacs-lisp
     
     ;; Tools
     helm
     multiple-cursors
     treemacs
     (shell :variables
            shell-default-height 30
            shell-default-position 'bottom)
     
     ;; Misc
     markdown
     org
     )

   ;; Additional packages
   dotspacemacs-additional-packages '(doom-themes
                                    modern-cpp-font-lock)
   ))

(defun dotspacemacs/init ()
  (setq-default
   ;; Startup
   dotspacemacs-elpa-https t
   dotspacemacs-elpa-timeout 5
   dotspacemacs-check-for-update nil
   
   ;; Editing
   dotspacemacs-editing-style 'vim
   dotspacemacs-vim-style-visual-feedback t
   dotspacemacs-ex-substitute-global nil
   
   ;; Display
   dotspacemacs-default-font '("Source Code Pro"
                              :size 14
                              :weight normal
                              :width normal)
   dotspacemacs-themes '(doom-one doom-dracula)
   dotspacemacs-mode-line-theme 'doom
   
   ;; Layout
   dotspacemacs-startup-banner nil
   dotspacemacs-startup-lists '((recents . 5)
                               (projects . 7))
   
   ;; Misc
   dotspacemacs-persistent-server nil
   dotspacemacs-search-tools '("rg" "ag" "pt" "ack" "grep")
   dotspacemacs-frame-title-format "%I@%S"
   dotspacemacs-whitespace-cleanup 'trailing
   ))

(defun dotspacemacs/user-init ()
  ;; This function is called at the very startup of Spacemacs initialization
  )

(defun dotspacemacs/user-config ()
  ;; Stanford CS107 inspired configurations
  
  ;; Whitespace mode
  (add-hook 'prog-mode-hook 'whitespace-mode)
  (setq whitespace-style '(face empty tabs lines-tail trailing))
  (setq whitespace-line-column 80)
  
  ;; Auto-fill in comments
  (add-hook 'prog-mode-hook 'auto-fill-mode)
  (setq comment-auto-fill-only-comments t)
  
  ;; Modern C++ support
  (use-package modern-cpp-font-lock
    :config
    (modern-c++-font-lock-global-mode t))
  
  ;; General settings
  (setq-default
   tab-width 4
   c-basic-offset 4
   indent-tabs-mode nil)
  
  ;; UTF-8 everywhere
  (prefer-coding-system 'utf-8)
  (set-default-coding-systems 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  
  ;; Backup settings
  (setq backup-directory-alist `(("." . "~/.emacs.d/backups")))
  (setq auto-save-file-name-transforms
        `((".*" "~/.emacs.d/auto-save-list/" t)))
  
  ;; Additional key bindings
  (global-set-key (kbd "C-x C-b") 'ibuffer)
  (global-set-key (kbd "M-/") 'hippie-expand)
  ) 