;;;; package --- summary

;;; Commentary:
;;;     place 'local-settings.el' file (provide 'local-settings)
;;;     in .emacs.d directory to overwrite settings (loaded at end)

;;; Code:

(let ((default-directory  (expand-file-name "lisp" user-emacs-directory)))
  (normal-top-level-add-to-load-path '("."))
  (normal-top-level-add-subdirs-to-load-path))

;; use-package to manage packages
(eval-when-compile
  (require 'use-package))

;;; backup settings
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq delete-old-versions -1)
(setq version-control t)
(setq vc-make-backup-files t)
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/tmp" t)))

;;; history settings
(setq savehist-file (expand-file-name "savehist" "~"))
(savehist-mode 1)
(setq history-length t)
(setq history-delete-duplicates t)
(setq savehist-save-minibuffer-history 1)
(setq savehist-additional-variables
      '(kill-ring
        search-ring
        regexp-search-ring))

(let ((home-settings (expand-file-name "home.el" user-emacs-directory)))
  (when (file-exists-p home-settings)
    (load-file home-settings)))

(setq custom-file (concat user-emacs-directory "shared-config.el"))

;;; byte recompile everything
;;;(byte-recompile-directory (expand-file-name "~/.emacs.d/lisp") 0)

;;; start emacsclient if server not running already
;;(load "server")
;;(unless (server-running-p) (server-start))

;;; make scrolling work like it should
(setq scroll-step 1)
(setq scroll-conservatively 10000)
(setq auto-window-vscroll nil)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
(setq mouse-wheel-progressive-speed nil)
(setq mouse-wheel-follow-mouse 't)

;;; cursor always blinks
(setq blink-cursor-blinks -1)

;;; visuals
(setq inhibit-startup-screen t)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)

;;; inhibit visual bells
(setq visible-bell nil
      ring-bell-function #'ignore)

;;; highlight current line
(global-hl-line-mode -1)
(defvar hl-line-face)
(set-face-attribute hl-line-face nil :underline nil)

;;; spaces by default instead of tabs!
(setq-default indent-tabs-mode nil)

;;; show matching parens
(show-paren-mode 1)

;;; smart parens
(electric-pair-mode -1)
(defun $inhibit-electric-pair-mode (char)
  "Do not use smart parens in mini-buffers.  Params: CHAR."
  (minibufferp))

(setq electric-pair-inhibit-predicate #'$inhibit-electric-pair-mode)

;;; turn on recent file mode
(recentf-mode t)
(setq recentf-max-saved-items 1000)

;;; filename in titlebar
(setq frame-title-format
      (concat "%f [%m]: " user-login-name "@" (system-name)))

;;; C-x w h [REGEX] <RET> <RET> to highlight all occurances of [REGEX], and C-x w r [REGEX] <RET> to unhighlight them again.
(global-hi-lock-mode 1)

;;; stop asking about upcase and downcase region
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;;; advanced management of rectangles
;; C-RET to mark a corner
;; M-r to do revexp replace within marked rectange
;; C-RET to unmark/exit rectangle editing
(cua-selection-mode 1)

;;; transient mark mode
(transient-mark-mode 1)
 
;;; LOAD INIT FILES
(use-package scwfri-defun)
(use-package theme-config)
(use-package scwfri-config)
(use-package modeline)
(use-package company-config)
(use-package ido-config)
(use-package smex-config)
(use-package org-config)
(use-package uniquify-config)
(use-package elpy-config)
(use-package slime-config)
(use-package ivy-config)
(use-package keybindings)
(use-package flycheck-config)
(use-package dumb-jump-config)
(use-package which-key-config)
(use-package origami-config)

;;; evil
(use-package evil
  :init
  (add-hook 'python-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))
  (add-hook 'ruby-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))
  (add-hook 'js2-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))
  (setf evil-want-keybinding 'nil)
  (setq evil-search-module 'evil-search)
  (setq evil-ex-complete-emacs-commands t)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  (setq evil-shift-round nil)
  (setq evil-want-C-u-scroll t)
  :config
  (evil-mode 1)
  ;;(defalias #'forward-evil-word #'forward-evil-symbol)
  ;; make evil-search-word look for symbol rather than word boundaries
  ;;(setq-default evil-symbol-word-search t)
  ;; Make horizontal movement cross lines
  (setq-default evil-cross-lines t)
  (define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
  (define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)
  (define-key evil-normal-state-map (kbd "u") '$simple-undo)
  (define-key evil-normal-state-map (kbd "C-r") '$simple-redo)
  (define-key evil-normal-state-map (kbd "C-l") 'evil-ex-nohighlight)
  (define-key evil-normal-state-map (kbd "C-]") 'counsel-etags-find-tag-at-point)
  (define-key evil-normal-state-map (kbd "\\w") 'delete-trailing-whitespace)
  (define-key evil-normal-state-map (kbd "\\f") 'find-name-dired)
  (define-key evil-normal-state-map (kbd "\\b") 'buffer-menu)
  (define-key evil-normal-state-map (kbd "\\h") 'highlight-symbol-at-point)
  (define-key evil-normal-state-map (kbd "\\H") 'unhighlight-regexp)
  (define-key evil-normal-state-map (kbd "\\c") 'global-hl-line-mode)
  (define-key evil-normal-state-map (kbd "\\C") 'column-marker-1)
  (define-key evil-normal-state-map (kbd "DEL") 'evil-switch-to-windows-last-buffer)
  (define-key evil-normal-state-map (kbd "C-c +") 'evil-numbers/inc-at-pt)
  (define-key evil-normal-state-map (kbd "C-c -") 'evil-numbers/dec-at-pt)
  (define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)
  (define-key evil-normal-state-map (kbd "*") '$evil-star-keep-position)
  (define-key evil-normal-state-map (kbd "]b") 'evil-next-buffer)
  (define-key evil-normal-state-map (kbd "[b") 'evil-prev-buffer)
  (define-key evil-normal-state-map (kbd "\\\\") 'imenu)
  (define-key evil-normal-state-map (kbd "\\pt") 'counsel-etags-list-tags)
  (define-key evil-normal-state-map (kbd "\\pT") 'list-tags)
  (define-key evil-normal-state-map (kbd "\\pr") '$ido-open-recentf)
  (define-key evil-normal-state-map (kbd "\\pb") 'ivy-switch-buffer)
  (define-key evil-normal-state-map (kbd "_f") '$show-full-file-path)
  (define-key evil-normal-state-map (kbd "SPC") 'counsel-grep)
  (define-key evil-normal-state-map (kbd "gr") 'counsel-git-grep)
  (define-key evil-normal-state-map (kbd "C-j") '$evil-scroll-down-keep-pos)
  (define-key evil-normal-state-map (kbd "C-k") '$evil-scroll-up-keep-pos)
  (define-key evil-visual-state-map (kbd "C-u") 'evil-scroll-up)
  (define-key evil-visual-state-map (kbd "j") 'evil-next-visual-line)
  (define-key evil-visual-state-map (kbd "k") 'evil-previous-visual-line)
  ;;(define-key evil-visual-state-map (kbd "*") '$visualstar-keep-position)
  (define-key evil-insert-state-map (kbd "C-u")
    (lambda ()
      (interactive)
      (evil-delete (point-at-bol) (point))))
  (define-key evil-normal-state-map (kbd "|") 'universal-argument)
  (evil-ex-define-cmd "Q" 'evil-quit)
  (evil-ex-define-cmd "E" 'evil-edit)
  (evil-ex-define-cmd "W" 'evil-write)
  (evil-ex-define-cmd "vs" '$evil-split-right-and-move)
  (evil-ex-define-cmd "Vs" '$evil-split-right-and-move)
  (define-key universal-argument-map (kbd "|") 'universal-argument-more)
  (define-key universal-argument-map (kbd "C-u") nil))

;;; evil-numbers
(use-package evil-numbers)

;;; evil-collection
(use-package evil-collection
  :config
  (evil-collection-init))

;;; evil-visualstar
(use-package evil-visualstar
  :config
  (global-evil-visualstar-mode))

;;; evil-surround
(use-package evil-surround
  :config
  (global-evil-surround-mode 1))

(use-package goto-chg)

;; PACKAGES

(use-package column-marker)

;;; LANGUAGE SETTINGS
;;; c++
(defun $c++-mode-hook ()
  "C++ mode stuff."
  (defvar c-basic-offset)
  (setq c-basic-offset 4)
  (c-set-offset 'substatement-open 0))
(add-hook 'c++-mode-hook '$c++-mode-hook)

;;; eldoc mode
(add-hook 'emacs-lisp-mode-hook 'eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'eldoc-mode)
(add-hook 'ielm-mode-hook 'eldoc-mode)

;;; LOAD LOCAL SETTINGS
(let ((local-settings (expand-file-name "local-settings.el" user-emacs-directory)))
  (when (file-exists-p local-settings)
    (load-file local-settings)))

(provide 'init.el)
;;; init.el ends here
