;;; init.el --- scwfri init.el
;;; Commentary:
;;     place 'local-settings.el' file (provide 'local-settings)
;;     in .emacs.d directory to overwrite settings (loaded at end)

;;; Code:

;;; add everything in lisp/ dir to load path
(let ((default-directory  (expand-file-name "lisp" user-emacs-directory)))
  (normal-top-level-add-to-load-path '("."))
  (normal-top-level-add-subdirs-to-load-path))

;;; use-package to manage packages
(eval-when-compile
  (require 'use-package)
  ;; do not add -hook suffix automatically in use-package :hook
  (setq use-package-hook-name-suffix nil))

;;; home.el
(let ((home-settings (expand-file-name "home.el" user-emacs-directory)))
  (when (file-exists-p home-settings)
    (load-file home-settings)))

;;; shared config not in init.el
(setq custom-file (expand-file-name "custom.el" temporary-file-directory))

  ;;; make scrolling work like it should
(setq scroll-step 1)
(setq scroll-conservatively 10000)
(setq auto-window-vscroll nil)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
(setq mouse-wheel-progressive-speed nil)
(setq mouse-wheel-follow-mouse 't)

;; cursor blinks n times
(setq blink-cursor-blinks 25)

;;; inhibit visual bells
(setq visible-bell nil)
(setq ring-bell-function #'ignore)

;;; transient mark mode
(setq transient-mark-mode t)

;;; spaces by default instead of tabs!
(setq-default indent-tabs-mode nil)

;;; ask about adding a final newline
(setq require-final-newline 'ask)

;;; allow recursive minibuffers
(setq enable-recursive-minibuffers t)

;;; overwrite highlighted text
(delete-selection-mode)

;;; allow disabled emacs commands (mainly for narrowing)
(setq disabled-command-function nil)

;;; do not ask about opening large files
(setf large-file-warning-threshold nil)

;;; show garbage collection messages in minbuffer
(setq garbage-collection-messages t)

;;; debug on error -- off for now
(setq debug-on-error nil)

;;; filename in titlebar
(setq frame-title-format
      (concat user-login-name "@" (system-name) ":%f [%m]"))

  ;;; Add prompt indicator to `completing-read-multiple'.
(defun crm-indicator (args)
  (cons (concat "[CRM] " (car args)) (cdr args)))
(advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;;; Grow and shrink minibuffer
(setq resize-mini-windows t)

  ;;; Do not allow the cursor in the minibuffer prompt
(setq minibuffer-prompt-properties
      '(read-only t cursor-intangible t face minibuffer-prompt))
(add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

;;; personal init files
(use-package scwfri-defun
  :hook
  ;; server postfix for tramp editing
  ;;(find-file-hook . $add-server-postfix)
  (kill-buffer-query-functions . $dont-kill-scratch)
  (kill-buffer-query-functions . $dont-kill-messages)
  :config
  (advice-add 'load-theme :before #'$load-theme--disable-current-theme))

;;; theme config
(use-package theme-config
  :demand
  :config
  ($set-path)
  :custom
  (custom-safe-themes t)
  :hook
  (after-init-hook . $set-preferred-font)
  (after-init-hook . $set-preferred-theme))

(use-package scwfri-config)
(use-package modeline)
(use-package keybindings)

(use-package dired
  :custom
  (dired-listing-switches "-alh"))

;;; themes
(use-package color-theme-sanityinc-tomorrow)
(use-package ample-theme)

;;; ir-black theme
(use-package ir-black-theme
  :config
  (with-eval-after-load "ir-black-theme"
    (custom-theme-set-faces
     'ir-black
     '(cursor ((t (:background "white"))))
     '(highlight ((t (:background "grey"))))
     '(italic ((t (:slant italic))))
     '(company-tooltip ((t (:background "#96CBFE" :foreground "black"))))
     '(cperl-array-face ((t (:inherit font-lock-keyword-face))))
     '(cperl-hash-face ((t (:inherit font-lock-variable-name-face)))))))

;;; modus-theme
(use-package modus-themes
  :commands (modus-themes-load-themes)
  :custom
  (modus-themes-slanted-constructs t)
  (modus-themes-bold-constructs nil)
  (modus-themes-diffs 'deuteranopia)
  :init
  (modus-themes-load-themes)
  :bind
  ("C-c C-t" . modus-themes-toggle))

;;; avy
(use-package avy
  :bind (("C-;" . avy-goto-char-2)
         ("s-;" . avy-goto-char-timer)))

;;; plus-minus
(use-package plus-minus
  :commands (+/-:forward+
             +/-:forward-
             +/-:backward+
             +/-:backward-
             +/-:block+
             +/-:block-)
  :bind
  (("C-c C-a"   . +/-:forward+)
   ("C-c C-x"   . +/-:forward-)
   ("C-c M-a"   . +/-:backward+)
   ("C-c M-x"   . +/-:backward-)
   ("C-c g C-a" . +/-:block+)
   ("C-c g C-x" . +/-:block-)))

;;; org-defun
(use-package org-defun
  :bind (("s-SPC" . $org-table--mark-field)))

;;; org-mode
(use-package org
  :commands (org-mode
             org-capture)
  :defer t
  :bind (("C-c l" . org-store-link)
         ("C-c a" . org-agenda)
         ("C-c c" . org-capture)
         ("C-c i" . org-id-copy))
  :config
  (add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
  :custom
  (org-hide-leading-stars t)
  (org-src-preserve-indentation nil)
  (org-edit-src-content-indentation 0)
  (org-log-done t)
  (org-startup-folded t)
  (org-agenda-files '("~/code/org"))
  (org-agenda-text-search-extra-files (directory-files-recursively "~/code" "*.md|*.org"))
  (org-todo-keywords
        '((sequence "TODO(t)" "STRT(s!)" "WAIT(w@/!)" "|" "DONE(d!)" "CNCL(c@)")
          (sequence "NEW(n)" "WORK(k!)" "PUSH-DEV(p!)" "REOPENED(r@/!)" "|" "STAGED(S!)" "RELEASED(R!)" "WONTFIX(w@)")))
  :hook
  (org-mode-hook . org-indent-mode))

;;; org-table
(use-package org-table)

;;; undohist
(use-package undohist
  :config
  (undohist-initialize))

;;; goto-chg
(use-package goto-chg)

;;; projectile
(use-package projectile
  :commands (projectile-mode)
  :init
  (projectile-mode)
  :custom
  (projectile-use-git-grep t)
  :bind (("C-c f" . projectile-find-file)
         ("C-c b" . projectile-switch-to-buffer)
         :map projectile-mode-map
         ("C-c p" . projectile-command-map)))

;;; project
(use-package project
  :config
  (defun $project-override (dir)
    (let ((override (locate-dominating-file dir ".project.el")))
      (if override
          (cons 'vc override)
        nil)))
  :hook
  (project-find-functions . $project-override))

;;; marginalia
(use-package marginalia
  :bind (:map minibuffer-local-map
              ("C-M-a" . marginalia-cycle))
  :commands (marginalia-mode)
  :init
  (marginalia-mode)
  (setq marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil)))

(use-package vertico
  :commands (vertico-mode)
  :init
  (vertico-mode))

;;; personal orderless functions
(use-package orderless-defun)

;;;; orderless
(use-package orderless
  :after (orderless-defun)
  :custom
  (completion-styles '(orderless))
  ;;(orderless-skip-highlighting (lambda () selectrum-is-active))
  ;;(selectrum-highlight-candidates-function #'orderless-highlight-matches)
  ;;(selectrum-refine-candidates-function #'orderless-filter)
  ;;(selectrum-highlight-candidates-function #'orderless-highlight-matches)
  (orderless-matching-styles '(orderless-flex))
  (orderless-style-dispatchers '($orderless-literal
                                 $orderless-strict-leading-initialism
                                 $orderless-initialism
                                 $orderless-regexp
                                 $orderless-flex
                                 $orderless-without-literal))
  :config
  (define-key minibuffer-local-map (kbd "C-l")
    #'$match-components-literally))

;;; consult
(use-package consult
  :bind (;;("C-s" . consult-line)
         ("s-s" . consult-line)
         ;; C-c bindings (mode-specific-map)
         ("C-c h" . consult-history)
         ("C-c m" . consult-mode-command)
         ("C-c b" . consult-bookmark)
         ("C-c k" . consult-kmacro)
         ;; C-x bindings (ctl-x-map)
         ("C-x M-:" . consult-complex-command)
         ("C-x b" . consult-buffer)
         ("C-x f" . consult-recent-file)
         ("C-x r j" . consult-register-load)
         ("C-x r J" . consult-register)
         ("C-x 4 b" . consult-buffer-other-window)
         ("C-x 5 b" . consult-buffer-other-frame)
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)
         ("<help> a" . consult-apropos)
         ;; M-g bindings (goto-map)
         ("M-g g" . consult-goto-line)
         ("M-g M-g" . consult-goto-line)
         ("M-g o" . consult-outline)
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-project-imenu)
         ("M-g e" . consult-error)
         ;; M-s bindings (search-map)
         ("M-s f" . consult-find)
         ("M-s L" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s m" . consult-multi-occur)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch)
         :map isearch-mode-map
         ("M-e" . consult-isearch)
         ("M-s e" . consult-isearch)
         ("M-s l" . consult-line))
  :commands (consult-register-window
             consult-multi-occur
             consult-register-format)
  :init
  ;; Replace `multi-occur' with `consult-multi-occur', which is a drop-in replacement.
  (fset 'multi-occur #'consult-multi-occur)
  ;; register preview setting
  (setq register-preview-delay 0)
  (setq register-preview-function #'consult-register-format)
  (advice-add #'register-preview :override #'consult-register-window)
  :config
  ;; configure preview keys
  (setq consult-config `((consult-theme :preview-key ,(kbd "M-+"))
                         (consult-buffer :preview-key ,(kbd "M-+"))
                         (consult-recent-file :preview-key ,(kbd "M-+"))
                         (consult-git-grep :preview-key ,(kbd "M-+"))
                         (consult-find :preview-key ,(kbd "M-+"))
                         (consult-locate :preview-key ,(kbd "M-+"))
                         (consult-grep :preview-key ,(kbd "M-+"))))
  ;; configure narrowing key.
  (setq consult-narrow-key (kbd "C-+"))
  ;; make narrowing help available in the minibuffer.
  (define-key consult-narrow-map (vconcat consult-narrow-key "?") #'consult-narrow-help)
  (autoload 'projectile-project-root "projectile")
  (setq consult-project-root-function #'projectile-project-root))

;;; consult-flycheck
(use-package consult-flycheck
  :bind (:map flycheck-command-map
              ("!" . consult-flycheck)))

;;; ctags
(use-package ctags
  :bind (("s-." . ctags-find)))

;;; term/ansi-term
(use-package term
  :config
  (defun $ansi-term()
    "Launch ansi-term using /bin/bash binary."
    (interactive)
    (ansi-term "/bin/bash"))
  :bind (("C-x T" . $ansi-term)))

;; magit
(use-package magit
  :defer t
  :commands (magit-status
             magit-diff-dwim
             magit-blame
             magit=diff-range)
  :init
  :bind (("C-x g" . magit-status)
         ("C-c g d" . magit-diff-range)
         ("C-c g b" . magit-blame))
  :config
  (add-to-list 'display-buffer-alist
               '("magit.*"
                 (display-buffer-at-bottom)
                 (window-height . 0.4))))

;;; company
(use-package company
  :commands (global-company-mode
             company-mode company-indent-or-complete-common)
  :bind (:map company-active-map
              ("C-n" . company-select-next)
              ("C-p" . company-select-previous)
              ("C-j" . company-select-next)
              ("C-k" . company-select-previous)
              ("<return>" . nil)
              ("RET" . nil)
              ("<tab>" . company-complete-selection)
              ("TAB" . company-complete-selection))
  :hook
  (after-init-hook . global-company-mode)
  :init
  (global-company-mode 1)
  :config
  (setq company-backends '((company-files company-keywords company-capf company-dabbrev-code company-etags company-dabbrev))))

;;; compile
(use-package compile
  :config
  (defun $python-compile-hook ()
    (set (make-local-variable 'compile-command)
          (format "pep8 --ignore=E501,E261,E262,E265,E266 --format=pylint %s" (buffer-name))))

  (defun $perl-compile-hook ()
    (set (make-local-variable 'compile-command)
         (format "perl -c %s" (buffer-name))))
  :hook
  (python-mode-hook . $python-compile-hook)
  (perl-mode-hook . $perl-compile-hook)
  (cperl-mode-hook . $perl-compile-hook)
  :bind ("<f5>" . recompile))

;;; show matching parens
(use-package paren
  :config
  (show-paren-mode 1))

;;; smart parens
(use-package elec-pair
  :commands (electric-pair-mode)
  :init
  (electric-pair-mode -1)
  :config
  (defun $inhibit-electric-pair-mode (char)
    "Do not use smart parens in mini-buffers.  Params: CHAR."
    (minibufferp))
  (setq electric-pair-inhibit-predicate #'$inhibit-electric-pair-mode))

;;; highlight current line
(use-package hl-line
  :config
  (global-hl-line-mode nil)
  (set-face-attribute hl-line-face nil :underline nil)
  :bind (("<f9>". hl-line-mode)))

;;; expand-region
(use-package expand-region
  :bind (("C-=" . er/expand-region)))

;;; nXml-mode
(use-package nxml-mode
  :defer t
  :config
  (defun $pretty-xml ()
    (interactive)
    (save-excursion
      (mark-whole-buffer)
      (shell-command-on-region (point-min) (point-max) "xmllint --format -" (buffer-name) t)
      (nxml-mode)
      (indent-region begin end))))

;;; flycheck
(use-package flycheck
  :defer 5
  :commands (flycheck-mode
             global-flycheck-mode)
  :custom
  (flycheck-standard-error-navigation nil)
  (flycheck-emacs-lisp-load-path 'inherit)
  :config
  (global-flycheck-mode))

;;; slime
(use-package slime
  :commands (slime)
  :init
  (setq inferior-lisp-program "/usr/bin/sbcl")
  :config
  (slime-setup '(slime-fancy slime-company))
  (defun $slime-keybindings ()
    "keybindings for use in slime"
    (local-set-key (kbd "C-c e") 'slime-eval-last-expression)
    (local-set-key (kbd "C-c b") 'slime-eval-buffer))
  (add-hook 'slime-mode-hook #'$slime-keybindings)
  (add-hook 'slime-repl-mode-hook #'$slime-keybindings)
  (setq slime-contribs '(slime-fancy))
  :hook
  (slime-mode-hook . (lambda ()
                       (load (expand-file-name "~/quicklisp/slime-helper.el"))
                       (add-to-list 'slime-contribs 'slime-fancy)
                       (add-to-list 'slime-contribs 'inferior-slime))))

;;; slime-company
(use-package slime-company
  :after (slime company)
  :config
  (setq slime-company-completion 'fuzzy)
  (setq slime-company-after-completion 'slime-company-just-one-space)
  :bind (:map company-active-map
              ("\C-n" . company-select-next)
              ("\C-p" . company-select-previous)
              ("\C-d" . company-show-doc-buffer)
              ("M-." . company-show-location)))

;;; eldoc mode
(use-package eldoc-mode
  :commands (eldoc-mode)
  :hook
  (emacs-lisp-mode-hook . eldoc-mode)
  (lisp-interaction-mode-hook . eldoc-mode)
  (ielm-mode-hook . eldoc-mode))

;;; markdown-mode
(use-package markdown-mode
  :commands (markdown-mode
             gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init
  (setq markdown-command "multimarkdown"))

;;; web-mode
(use-package web-mode
  :custom
  (web-mode-markup-indent-offset 2)
  (web-mode-css-indent-offset 2)
  (web-mode-code-indent-offset 2)
  :mode ("\\.phtml\\'"
         "\\.tpl\\.php\\'"
         "\\.[agj]sp\\'"
         "\\.as[cp]x\\'"
         "\\.erb\\'"
         "\\.mustache\\'"
         "\\.djhtml\\'"))

;;; cperl-mode
(use-package cperl-mode
  :commands (cperl-mode)
  :init
  (mapc
   (lambda (pair)
     (if (eq (cdr pair) 'perl-mode)
         (setcdr pair 'cperl-mode)))
   (append auto-mode-alist interpreter-mode-alist))
  :custom
  (cperl-invalid-face nil)
  (cperl-highlight-variables-indiscriminately t)
  :config
  (modify-syntax-entry ?: "-" cperl-mode-syntax-table))

;;; c++-mode
(use-package c++-mode
  :commands (c++-mode)
  :custom
  (c-basic-offset 2)
  :config
  (c-set-offset 'substatement-open 0))

;;; projectile-rails
(use-package projectile-rails
  :commands (projectile-rails-mode
             projectile-rails-command-map)
  :bind (("C-c R" . projectile-rails-command-map))
  :config
  (projectile-rails-global-mode)
  :hook
  (ruby-mode-hook . projectile-rails-mode))

;;; uniquify
(use-package uniquify
  :custom
  (uniquify-buffer-name-style 'forward)
  (uniquify-separator "/")
  ;; rename after killing unqualified
  (uniquify-after-kill-buffer-p t)
  ;; dont change names of special buffers
  (uniquify-ignore-buffers-re "^\\*"))

;;; ace-window
(use-package ace-window
  :custom
  (aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
  :bind (("M-o" . ace-window)
         ("M-O" . ace-delete-window)
         ("s-o" . ace-window)
         ("s-O" . ace-delete-window)))

;;; display-buffer (most/all of this taken from prot)
(use-package window
  :custom
  (display-buffer-alist
        '(;; top side window
          ("\\*\\(Flymake\\|Package-Lint\\|vc-git :\\).*"
           (display-buffer-in-side-window)
           (window-height . 0.16)
           (side . top)
           (slot . 0)
           (window-parameters . ((no-other-window . t))))
          ("\\*Messages.*"
           (display-buffer-in-side-window)
           (window-height . 0.16)
           (side . top)
           (slot . 1)
           (window-parameters . ((no-other-window . t))))
          ("\\*\\(Backtrace\\|Warnings\\|Compile-Log\\)\\*"
           (display-buffer-in-side-window)
           (window-height . 0.16)
           (side . top)
           (slot . 2)
           (window-parameters . ((no-other-window . t))))
          ;; bottom side window
          ("\\*\\(Embark\\)?.*Completions.*"
           (display-buffer-in-side-window)
           (side . bottom)
           (slot . 0)
           (window-parameters . ((no-other-window . t)
                                 (mode-line-format . none))))
          ;; left side window
          ("\\*Help.*"
           (display-buffer-at-bottom)
           (window-width . 0.25)
           (side . left)
           (slot . 0)
           (window-parameters . ((no-other-window . t))))
          ;; right side window
          ("\\*Faces\\*"
           (display-buffer-in-side-window)
           (window-width . 0.25)
           (side . right)
           (slot . 0)
           (window-parameters
            . ((mode-line-format
                . (" "
                   mode-line-buffer-identification)))))
          ("\\*Custom.*"
           (display-buffer-in-side-window)
           (window-width . 0.3)
           (side . right)
           (slot . 1)
           (window-parameters . ((no-other-window . t))))
          ;; bottom buffer (NOT side window)
          ("\\*\\vc-\\(incoming\\|outgoing\\).*"
           (display-buffer-at-bottom))
          ("\\*\\(Output\\|Register Preview\\).*"
           (display-buffer-at-bottom)
           (window-parameters . ((no-other-window . t))))
          ("\\*.*\\([^E]eshell\\|shell\\|v?term\\|xref\\|compilation\\|Occur\\).*"
           (display-buffer-reuse-mode-window display-buffer-at-bottom)
           (window-height . 0.25))))
  (window-combination-resize t)
  (even-window-sizes 'height-only)
  (window-sides-vertical nil)
  (switch-to-buffer-in-dedicated-window 'pop)
  :hook ((help-mode-hook . visual-line-mode)))

;;; winner-mode
(use-package winner
  :hook
  (after-init-hook . winner-mode)
  :bind(("s-<" . winner-undo)
        ("s->" . winner-redo)))

;;; windmove
(use-package windmove
  :custom
  (windmove-create-window nil)
  :bind (("C-c <up>" . windmove-up)
         ("C-c <down>" . windmove-down)
         ("C-c <left>" . windmove-left)
         ("C-c <right>" . windmove-right)))

;;; tab-bar (again, most/all of this taken from prot)
(use-package tab-bar
  :custom
  (tab-bar-close-button-show nil)
  (tab-bar-close-last-tab-choice 'tab-bar-mode-disable)
  (tab-bar-close-tab-select 'recent)
  (tab-bar-new-tab-choice t)
  (tab-bar-new-tab-to 'right)
  (tab-bar-position nil)
  (tab-bar-show nil)
  (tab-bar-tab-hints t)
  (tab-bar-tab-name-function 'tab-bar-tab-name-current)

  :config
  (tab-bar-mode -1)
  (tab-bar-history-mode 1)
  (defun $tab--tab-bar-tabs ()
    "Return a list of `tab-bar' tabs, minus the current one."
    (mapcar (lambda (tab)
              (alist-get 'name tab))
            (tab-bar--tabs-recent)))

  (defun $tab-select-tab-dwim ()
    "Do-What-I-Mean function for getting to a `tab-bar' tab.
If no other tab exists, create one and switch to it.  If there is
one other tab (so two in total) switch to it without further
questions.  Else use completion to select the tab to switch to."
    (interactive)
    (let ((tabs ($tab--tab-bar-tabs)))
      (cond ((eq tabs nil)
             (tab-new))
            ((eq (length tabs) 1)
             (tab-next))
            (t
             (tab-bar-switch-to-tab
              (completing-read "Select tab: " tabs nil t))))))

  (defun $tab-tab-bar-toggle ()
    "Toggle `tab-bar' presentation."
    (interactive)
    (if (bound-and-true-p tab-bar-mode)
        (progn
          (setq tab-bar-show nil)
          (tab-bar-mode -1))
      (setq tab-bar-show t)
      (tab-bar-mode 1)))

  :bind (("C-x t h" . tab-bar-history-forward)
         ("C-x t l" . tab-bar-history-back)
         ("C-x t n" . tab-next)
         ("C-x t p" . tab-previous)
         ("<s-tab>" . tab-next)
         ("<S-s-iso-lefttab>" . tab-previous)
         ("<f8>" . $tab-tab-bar-toggle)
         ("C-x t k" . tab-close)
         ("C-x t c" . tab-new)
         ("C-x t t" . $tab-select-tab-dwim)
         ("s-t" . $tab-select-tab-dwim)))
         
;;; which-key
(use-package which-key
  :config
  (which-key-mode))

;;; fold-this
(use-package fold-this
  :bind (("C-c C-f" . fold-this-all)
         ("C-c C-F" . fold-this)
         ("C-c M-f" . fold-this-unfold-all)))

;;; idle-highlight-mode
(use-package idle-highlight-mode)
  
;;; hi-lock
(use-package hi-lock
  :config
  ;; make hl-lock play nice with idle-highlight-mode
  (defun $enable-idle-highlight-mode ()
    (setq idle-highlight-mode t))
  (defun $disable-idle-highlight-mode ()
    (setq idle-highlight-mode nil))
  ;;(advice-add 'highlight-symbol-at-point :before '$disable-idle-highlight-mode)
  ;;(advice-add 'highlight-symbol-at-point :after '$enable-idle-highlight-mode)
  ;; C-x w h [REGEX] <RET> <RET> to highlight all occurances of [REGEX], and C-x w r [REGEX] <RET> to unhighlight them again.
  (global-hi-lock-mode 1))

;;; hl-todo
(use-package hl-todo
  :hook (prog-mode-hook . hl-todo-mode)
  :config
  (setq hl-todo-keyword-faces
        '(("TODO"   . "#FFFF00")
          ("FIXME"  . "#FFFFFF")
          ("NOTE"   . "#F56600")
          ("WORK"   . "#522D80")))
  :bind (:map hl-todo-mode-map
              ("C-c t p" . hl-todo-previous)
              ("C-c t n" . hl-todo-next)
              ("C-c t o" . hl-todo-occur)
              ("C-c t i" . hl-todo-insert)))

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
  (add-to-list 'recentf-exclude "*/.ido.last")
  (add-to-list 'recentf-exclude "*/TAGS")
  (add-to-list 'recentf-exclude no-littering-var-directory)
  (add-to-list 'recentf-exclude no-littering-etc-directory)
  ;; backup settings
  :custom
  (recentf-max-saved-items 1000)
  (delete-old-versions -1)
  (version-control t)
  (vc-make-backup-files t)

  ;; history settings
  (history-length t)
  (history-delete-duplicates t)
  (savehist-save-minibuffer-history 1)
  (savehist-additional-variables
   '(kill-ring
     search-ring
     regexp-search-ring)))

;;; tags
(use-package etags
  :custom
  (tags-revert-without-query 1))

;;; visual-regexp
(use-package visual-regexp
  :bind (("C-c r" . vr/replace)
         ("C-c q" . vr/query-replace)))

;;; load local settings
(let ((local-settings (expand-file-name "local-settings.el" user-emacs-directory)))
  (when (file-exists-p local-settings)
    (load-file local-settings)))

(provide 'init.el)
;;; init.el ends here
