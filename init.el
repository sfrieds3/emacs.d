;;; init.el --- scwfri init.el

;;; Commentary:
;;     place 'local-settings.el' file (provide 'local-settings)
;;     in .emacs.d directory to overwrite settings (loaded at end)

;;; Code:

(let ((default-directory  (expand-file-name "lisp" user-emacs-directory)))
  (normal-top-level-add-to-load-path '("."))
  (normal-top-level-add-subdirs-to-load-path))

;; use-package to manage packages
(eval-when-compile
  (require 'use-package))

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

(setq require-final-newline 'ask)

;;; show matching parens
(show-paren-mode 1)

;;; smart parens
(electric-pair-mode -1)
(defun $inhibit-electric-pair-mode (char)
  "Do not use smart parens in mini-buffers.  Params: CHAR."
  (minibufferp))
(setq electric-pair-inhibit-predicate #'$inhibit-electric-pair-mode)

;;; allow recursive minibuffers
(setq enable-recursive-minibuffers t)

;;; filename in titlebar
(setq frame-title-format
      (concat user-login-name "@" (system-name) ":%f [%m]"))

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

;;; personal init files
(use-package scwfri-defun
  :config
  ;; server postfix for tramp editing
  (add-hook 'find-file-hook '$add-server-postfix))

(use-package theme-config)
(use-package scwfri-config)
(use-package modeline)
(use-package keybindings)

;;; dependencies
(use-package annalist              :defer t)
(use-package dash                  :defer t)
(use-package f                     :defer t)
(use-package highlight-indentation :defer t)
(use-package ht                    :defer t)
(use-package hydra                 :defer t)
(use-package popup                 :defer t)
(use-package pyvenv                :defer t)
(use-package s                     :defer t)
(use-package spinner               :defer t)
(use-package inf-ruby              :defer t)

;;; evil
(use-package evil
  :init
  (setf evil-want-keybinding 'nil)
  :config
  (add-hook 'python-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))
  (add-hook 'ruby-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))
  (add-hook 'js2-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))
  (setq evil-search-module 'evil-search)
  (setq evil-ex-complete-emacs-commands t)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  (setq evil-shift-round nil)
  (setq evil-want-C-u-scroll t)
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

  ;; NORMAL


  ;; local leader
  (define-key evil-normal-state-map (kbd "_h") 'idle-highlight-mode)
  (define-key evil-normal-state-map (kbd "_w") '$toggle-show-trailing-whitespace)
  (define-key evil-normal-state-map (kbd "_f") '$show-full-file-path)

  ;; leader
  (define-key evil-normal-state-map (kbd "\\w") 'delete-trailing-whitespace)
  (define-key evil-normal-state-map (kbd "\\f") 'find-name-dired)
  (define-key evil-normal-state-map (kbd "\\b") 'buffer-menu)
  (define-key evil-normal-state-map (kbd "\\g") 'counsel-git-grep)
  (define-key evil-normal-state-map (kbd "\\h") 'highlight-symbol-at-point)
  (define-key evil-normal-state-map (kbd "\\H") 'unhighlight-regexp)
  (define-key evil-normal-state-map (kbd "\\c") 'global-hl-line-mode)
  (define-key evil-normal-state-map (kbd "\\C") 'column-marker-1)
  (define-key evil-normal-state-map (kbd "\\\\") 'counsel-imenu)
  (define-key evil-normal-state-map (kbd "\\pt") 'counsel-etags-list-tag)
  (define-key evil-normal-state-map (kbd "\\pT") 'list-tags)
  (define-key evil-normal-state-map (kbd "\\pr") 'counsel-recentf)
  (define-key evil-normal-state-map (kbd "\\pb") 'counsel-buffer-or-recentf)

  ;; other

  (define-key evil-normal-state-map (kbd "C-r") '$simple-redo)
  (define-key evil-normal-state-map (kbd "C-l") 'evil-ex-nohighlight)
  (define-key evil-normal-state-map (kbd "C-]") 'counsel-etags-find-tag-at-point)
  (define-key evil-normal-state-map (kbd "C-j") '$evil-scroll-down-keep-pos)
  (define-key evil-normal-state-map (kbd "C-k") '$evil-scroll-up-keep-pos)
  (define-key evil-normal-state-map (kbd "C-c +") 'evil-numbers/inc-at-pt)
  (define-key evil-normal-state-map (kbd "C-c -") 'evil-numbers/dec-at-pt)
  (define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)

  (define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
  (define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)
  (define-key evil-normal-state-map (kbd "u") '$simple-undo)
  (define-key evil-normal-state-map (kbd "]b") 'evil-next-buffer)
  (define-key evil-normal-state-map (kbd "[b") 'evil-prev-buffer)
  (define-key evil-normal-state-map (kbd "gb") 'evil-next-buffer)
  (define-key evil-normal-state-map (kbd "gB") 'evil-prev-buffer)
  (define-key evil-normal-state-map (kbd "SPC") 'counsel-grep)
  (define-key evil-normal-state-map (kbd "gr") 'projectilel-grep)
  (define-key evil-normal-state-map (kbd "*") '$evil-star-keep-position)
  (define-key evil-normal-state-map (kbd "DEL") 'evil-switch-to-windows-last-buffer)

  ;; VISUAL
  (define-key evil-visual-state-map (kbd "C-u") 'evil-scroll-up)
  (define-key evil-visual-state-map (kbd "j") 'evil-next-visual-line)
  (define-key evil-visual-state-map (kbd "k") 'evil-previous-visual-line)
  (define-key evil-visual-state-map (kbd "gl") 'align-regexp)
  ;;(define-key evil-visual-state-map (kbd "*") '$visualstar-keep-position)

  ;; INSERT
  (define-key evil-insert-state-map (kbd "TAB") 'tab-to-tab-stop)
  (define-key evil-insert-state-map (kbd "C-u")
    (lambda ()
      (interactive)
      (evil-delete (point-at-bol) (point))))

  (evil-ex-define-cmd "Q" 'evil-quit)
  (evil-ex-define-cmd "E" 'evil-edit)
  (evil-ex-define-cmd "W" 'evil-write)
  (evil-ex-define-cmd "vs" '$evil-split-right-and-move)
  (evil-ex-define-cmd "Vs" '$evil-split-right-and-move)

  (define-key evil-normal-state-map (kbd "M-u") 'universal-argument)
  (define-key universal-argument-map (kbd "M-u") 'universal-argument-more)
  (define-key universal-argument-map (kbd "C-u") nil))

;;; evil-numbers
(use-package evil-numbers)

;;; evil-collection
(use-package evil-collection
  :commands (evil-collection-init)
  :init
  (evil-collection-init))

;;; evil-visualstar
(use-package evil-visualstar
  :config
  (global-evil-visualstar-mode))

;;; evil-surround
(use-package evil-surround
  :config
  (global-evil-surround-mode 1))

;;; evil-matchit
(use-package evil-matchit
  :config
  (global-evil-matchit-mode 1))

;;; undohist
(use-package undohist
  :config
  (undohist-initialize))

;;; goto-chg
(use-package goto-chg)

;;; projectile
(use-package projectile
  :config
  (projectile-mode)
  (setq projectile-use-git-grep t)
  (define-key projectile-mode-map (kbd "M-p") 'projectile-command-map)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  :bind (("C-c f" . projectile-find-file)))

;;; ivy
(use-package ivy
  :defer 1
  :diminish
  :config
  (ivy-mode 1)

  (defun $ivy-switch-file-search ()
    "Switch to counsel-file-jump, preserving current input."
    (interactive)
    (let ((input (ivy--input)))
      (ivy-quit-and-run (counsel-file-jump))))
  (define-key ivy-minibuffer-map (kbd "M-s r") '$ivy-switch-file-search)

  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)
  :bind (("C-c C-r" . ivy-resume)))

;;; counsel
(use-package counsel
  :after ivy
  :bind (("C-x C-f" . counsel-find-file)
         ("C-x f" . counsel-recentf)
         ("C-s" . counsel-grep-or-swiper)
         ("C-c h f" . counsel-describe-function)
         ("C-c h v" . counsel-describe-variable)
         ("C-c h d" . counsel-describe-symbol)
         ("C-c k" . counsel-find-library)
         ("C-c i" . counsel-info-lookup-symbol)
         ("C-c u" . counsel-unicode-char)
         ("C-c f" . counsel-git)
         ("C-c g g" . counsel-git-grep)
         ("C-x l" . counsel-locate)
         ("M-x" . counsel-M-x)))

;;; swiper
(use-package swiper
  :after ivy)

(use-package prescient)

(use-package ivy-prescient
  :after prescient
  :config
  (ivy-prescient-mode))

(use-package company-prescient
  :after prescient
  :config
  (company-prescient-mode))

;;; counsel-etags
(use-package counsel-etags
  :after counsel
  :commands (counsel-etags-find-tag-at-point
             counsel-etags-find-tag counsel-etags-list-tag
             counsel-etags-virtual-update-tags)
  :bind (("C-]" . counsel-etags-find-tag-at-point))
  :init
  (add-hook 'prog-mode-hook
            (lambda ()
              (add-hook 'after-save-hook
                        'counsel-etags-virtual-update-tags 'append 'local)))
  :config
  (setq counsel-etags-update-interval 60)
  (setq tags-revert-without-query t)
  (setq large-file-warning-threshold nil)
  (push "tmp" counsel-etags-ignore-directories)
  (push "bin" counsel-etags-ignore-directories)
  (push "build" counsel-etags-ignore-directories)
  (push "var" counsel-etags-ignore-directories))

;;; find-file-in-project
(use-package find-file-in-project
  :defer t
  :commands (find-file-in-project
             find-file-in-current-directory
             find-file-in-project-at-point)
  :config
  (defun ffip-diff-mode-hook-setup ()
    (evil-local-set-key 'normal "p" 'diff-hunk-prev)
    (evil-local-set-key 'normal "n" 'diff-hunk-next)
    (evil-local-set-key 'normal "P" 'diff-file-prev)
    (evil-local-set-key 'normal "N" 'diff-file-next)
    (evil-local-set-key 'normal (kbd "RET") 'ffip-diff-find-file)
    (evil-local-set-key 'normal "o" 'ffip-diff-find-file))
  (add-hook 'ffip-diff-mode-hook 'ffip-diff-mode-hook-setup))

;;; smex
(use-package smex
  :disabled
  :commands (smex smex-initialize)
  :defer t
  :config
  (smex-initialize)
  :bind (("M-x" . smex)
         ("M-X" . smex-major-mode-commands)
         ;; This is your old M-x.
         ("C-c C-c M-x" . execute-extended-command)))

;;; company
(use-package company
  :demand t
  :commands (global-company-mode company-mode company-indent-or-complete-common)
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
  :defer 5
  :config
  (global-flycheck-mode))

;;; elpy
(use-package elpy
  :defer t
  :commands (elpy-enable)
  :init
  (advice-add 'python-mode :before 'elpy-enable)
  :config
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (setq elpy-modules (delq 'elpy-module-yasnippet elpy-modules))
  (add-hook 'elpy-mode-hook (lambda () (highlight-indentation-mode -1)))
  (add-hook 'python-mode-hook (lambda()
                                (set (make-local-variable 'company-backends)
                                     (list 'elpy-company-backend 'company-backends))))
  :hook
  (elpy-mode-hook . flycheck-mode))

;;; yasnippet
(use-package yasnippet
  :defer t)

;;; slime
(use-package slime
  :defer t
  :commands (slime)
  :init
  (setq inferior-lisp-program "/usr/bin/sbcl")
  :config
  (slime-setup '(slime-fancy slime-company))
  (defun my/slime-keybindings ()
    "keybindings for use in slime"
    (local-set-key (kbd "C-c e") 'slime-eval-last-expression)
    (local-set-key (kbd "C-c b") 'slime-eval-buffer))
  (add-hook 'slime-mode-hook #'my/slime-keybindings)
  (add-hook 'slime-repl-mode-hook #'my/slime-keybindings)
  (add-hook 'slime-mode-hook
            (lambda ()
              (load (expand-file-name "~/quicklisp/slime-helper.el"))
              (add-to-list 'slime-contribs 'slime-fancy)
              (add-to-list 'slime-contribs 'inferior-slime)))
  (setq slime-contribs '(slime-fancy)))

;;; slime-company
(use-package slime-company
  :after (slime company)
  :config
  (setq slime-company-completion 'fuzzy)
  (setq slime-company-after-completion 'slime-company-just-one-space)
  (define-key company-active-map (kbd "\C-n") 'company-select-next)
  (define-key company-active-map (kbd "\C-p") 'company-select-previous)
  (define-key company-active-map (kbd "\C-d") 'company-show-doc-buffer)
  (define-key company-active-map (kbd "M-.") 'company-show-location))

;;; eldoc mode
(use-package eldoc-mode
  :defer t
  :commands (eldoc-mode)
  :hook
  (emacs-lisp-mode-hook . eldoc-mode)
  (lisp-interaction-mode-hook . eldoc-mode)
  (ielm-mode-hook . eldoc-mode))


;;; markdown-mode
(use-package markdown-mode
  :defer t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init
  (setq markdown-command "multimarkdown"))

;;; web-mode
(use-package web-mode
  :defer t
  :mode ("\\.phtml\\'"
         "\\.tpl\\.php\\'"
         "\\.[agj]sp\\'"
         "\\.as[cp]x\\'"
         "\\.erb\\'"
         "\\.mustache\\'"
         "\\.djhtml\\'"))

(use-package cperl-mode
  :defer t
  :commands (cperl-mode)
  :init
  (mapc
    (lambda (pair)
      (if (eq (cdr pair) 'perl-mode)
          (setcdr pair 'cperl-mode)))
    (append auto-mode-alist interpreter-mode-alist)))

;;; projectile-rails
(use-package projectile-rails
  :defer t
  :commands (projectile-rails-mode)
  :bind (("C-c r" . projectile-rails-command-map))
  :config
  (projectile-rails-global-mode)
  :hook
  (ruby-mode . projectile-rails-mode))

;;; dumb-jump
(use-package dumb-jump
  :defer 5
  :config
  (add-to-list 'xref-backend-functions 'dumb-jump-xref-activate t) )

;;; uniquify
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

;;; origami
(use-package origami
  :defer 5
  :commands (global-origami-mode)
  :init
  (global-origami-mode 1))

;;; idle-highlight-mode
(use-package idle-highlight-mode
  :hook
  (prog-mode . idle-highlight-mode))

;;; column-marker
(use-package column-marker)

;;; helpful
(use-package helpful
  :defer t
  :bind (("C-h f" . helpful-callable)
         ("C-h v" . helpful-variable)
         ("C-h k" . helpful-key)))

;;; no-littering
(use-package no-littering
  :init
  (savehist-mode 1)
  :config
  (recentf-mode t)
  (setq recentf-max-saved-items 1000)
  (add-to-list 'recentf-exclude "*/.ido.last")
  (add-to-list 'recentf-exclude "*/TAGS")
  (add-to-list 'recentf-exclude no-littering-var-directory)
  (add-to-list 'recentf-exclude no-littering-etc-directory)
  ;; backup settings
  ;;(setq backup-directory-alist '(("." . "~/.emacs.d/tmp/")))
  (setq delete-old-versions -1)
  (setq version-control t)
  (setq vc-make-backup-files t)
  ;;(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/tmp/" t)))

  ;; history settings
  ;;(setq savehist-file (expand-file-name "savehist" "~"))
  (setq history-length t)
  (setq history-delete-duplicates t)
  (setq savehist-save-minibuffer-history 1)
  (setq savehist-additional-variables
        '(kill-ring
          search-ring
          regexp-search-ring)))

;;; esup
(use-package esup
  :defer t
  :commands (esup)
  :config
  (setq esup-depth 0))

;;; LANGUAGE SETTINGS

;;; c++
(defun $c++-mode-hook ()
  "C++ mode stuff."
  (defvar c-basic-offset)
  (setq c-basic-offset 4)
  (c-set-offset 'substatement-open 0))
(add-hook 'c++-mode-hook '$c++-mode-hook)

;;; LOAD LOCAL SETTINGS
(let ((local-settings (expand-file-name "local-settings.el" user-emacs-directory)))
  (when (file-exists-p local-settings)
    (load-file local-settings)))

(provide 'init.el)
;;; init.el ends here
