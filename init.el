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
(setq backup-directory-alist '(("." . "~/.emacs.d/tmp/")))
(setq delete-old-versions -1)
(setq version-control t)
(setq vc-make-backup-files t)
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/tmp/" t)))

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
  (setq-default evil-cross-lines t)

  (defun $evil-clear-highlights ()
    "Clear highlight from evil-search."
    (interactive)
    (evil-ex "nohl")
    (exit-minibuffer))

  (defun $evil-star-keep-position ()
    "Keep position when searching."
    (interactive)
    (evil-search-word-forward)
    (evil-search-previous))

  (defun $evil-visualstar-keep-position ()
    "Keep current position on visual star search."
    (interactive)
    (when (region-active-p)
      (evil-search-word-forward)
      (evi-search-word-backward)
      (cua-cancel)))

  (defun $evil-set-jump-args (&rest ns)
    "Preserve jump list with dumb-jump.  NS args."
    (evil-set-jump))
  (advice-add 'dumb-jump-goto-file-line :before #'$evil-set-jump-args)

  (defun $evil-split-right-and-move ()
    "Split window to the right and move to it."
    (interactive)
    (split-window-right)
    (evil-window-right 1))

  (defun $evil-scroll-down-keep-pos ()
    (interactive)
    (evil-scroll-line-down 1)
    (evil-next-visual-line))

  (defun $evil-scroll-up-keep-pos ()
    (interactive)
    (evil-scroll-line-up 1)
    (evil-previous-visual-line))

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

;;; goto-chg
(use-package goto-chg)

;;; ivy
(use-package ivy
  :diminish
  :config
  (ivy-mode 1)

  (defun my-ivy-switch-file-search ()
    "Switch to counsel-file-jump, preserving current input."
    (interactive)
    (let ((input (ivy--input)))
      (ivy-quit-and-run (counsel-file-jump))))
  (define-key ivy-minibuffer-map (kbd "M-s r") 'my-ivy-switch-file-search)

  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  ;; enable this if you want `swiper' to use it
  ;; (setq search-default-mode #'char-fold-to-regexp)
  (global-set-key (kbd "C-c C-r") 'ivy-resume)
  (global-set-key (kbd "<f6>") 'ivy-resume)
  ;;(global-set-key (kbd "M-x") 'counsel-M-x)
  (global-set-key (kbd "<f1> f") 'counsel-describe-function)
  (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
  (global-set-key (kbd "<f1> o") 'counsel-describe-symbol)
  (global-set-key (kbd "<f1> l") 'counsel-find-library)
  (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
  (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
  (global-set-key (kbd "C-c f") 'counsel-git)
  (global-set-key (kbd "C-c j") 'counsel-git-grep)
  (global-set-key (kbd "C-x l") 'counsel-locate)
  (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history))

;;; counsel
(use-package counsel
  :after ivy
  :demand t
  :bind (("C-x C-f" . counsel-find-file)
        ("C-s" . counsel-grep-or-swiper)))

;;; swiper
(use-package swiper
  :after ivy
  :demand t)

;;; counsel-etags
(use-package counsel-etags
  :after counsel
  :demand t)

;;; smex
(use-package smex
  :config
  (smex-initialize)
  (global-set-key (kbd "M-x") 'smex)
  (global-set-key (kbd "M-X") 'smex-major-mode-commands)
  ;; This is your old M-x.
  (global-set-key (kbd "C-c C-c M-x") 'execute-extended-command))

;;; company
(use-package company
  :commands (global-company-mode company-mode company-indent-or-complete-common)
  :demand t
  :bind (:map company-active-map
              ("C-n" . company-select-next)
              ("C-p" . company-select-previous))
  :init
  (add-hook 'after-init-hook 'global-company-mode)
  :config
  (setq company-backends '((company-files company-keywords company-capf company-dabbrev-code company-etags company-dabbrev)))
  (global-company-mode 1))

;;; flycheck
(use-package flycheck
  :demand t
  :config
  (global-flycheck-mode))

;;; elpy
;; does not play nice with use-package, so we'll do it the semi-old fashioned way
(use-package emacs
  :defer t
  :init
  (load "elpy")
  (load "elpy-rpc")
  (load "elpy-shell")
  (load "elpy-profile")
  (load "elpy-refactor")
  (load "elpy-django")
  (elpy-enable)
  :config
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook (lambda () (highlight-indentation-mode -1)))
  (add-hook 'python-mode-hook (lambda()
                       (make-local-variable 'company-backends)
                       (setq company-backends (list (cons 'elpy-company-backend (copy-tree (car company-backends)))))))
  :hook
  (elpy-mode-hook . flycheck-mode))

(use-package slime
  :init
  (defun my/slime-keybindings ()
    "keybindings for use in slime"
    (local-set-key (kbd "C-c e") 'slime-eval-last-expression)
    (local-set-key (kbd "C-c b") 'slime-eval-buffer))
  (add-hook 'slime-mode-hook #'my/slime-keybindings)
  (add-hook 'slime-repl-mode-hook #'my/slime-keybindings)
  :config
  (setq inferior-lisp-program "/usr/bin/sbcl")
  (setq slime-contribs '(slime-fancy)))

(use-package dumb-jump
  :config
  (add-to-list 'xref-backend-functions 'dumb-jump-xref-activate t) )

(use-package uniquify
  :custom
  (uniquify-buffer-name-style 'forward)
  (uniquify-separator "/")
  ;; rename after killing unqualified
  (uniquify-after-kill-buffer-p t)
  ;; dont change names of special buffers
  (uniquify-ignore-buffers-re "^\\*"))

;;; which-key
(use-package which-key
  :config
  (which-key-mode))

;; origami
(use-package origami
  :config
  (global-origami-mode 1))

;;; column-marker
(use-package column-marker)

;;; LOAD INIT FILES
(use-package scwfri-defun)
(use-package theme-config)
(use-package scwfri-config)
(use-package modeline)
(use-package ido-config)
(use-package org-config)
(use-package keybindings)
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
