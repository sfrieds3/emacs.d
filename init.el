;;; init.el --- scwfri init.el
;;; Commentary:
;;     place 'local-settings.el' file (provide 'local-settings)
;;     in .emacs.d directory to overwrite settings (loaded at end)

;;; Code:

;;; add everything in lisp/ dir to load path
(let ((default-directory  (expand-file-name "lisp" user-emacs-directory)))
  (normal-top-level-add-to-load-path '("."))
  (normal-top-level-add-subdirs-to-load-path))

;;; try not to gc during emacs startup... set to 10MB from 800kb
(setq gc-cons-threshold 10000000)
(add-hook 'after-init-hook
          (lambda ()
            (setq gc-cons-threshold 1000000)
            (message "gc-cons-threshold restored to %S"
                     gc-cons-threshold)))

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
(setq custom-file (concat user-emacs-directory "shared-config.el"))

;;; make scrolling work like it should
(setq scroll-step 1)
(setq scroll-conservatively 10000)
(setq auto-window-vscroll nil)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
(setq mouse-wheel-progressive-speed nil)
(setq mouse-wheel-follow-mouse 't)

;; cursor blinks n times
(setq blink-cursor-blinks 25)

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

;;; transient mark mode off
(setq transient-mark-mode nil)

;;; spaces by default instead of tabs!
(setq-default indent-tabs-mode nil)

;;; ask about adding a final newline
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

;;; allow narrowing commands
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)

;;; show garbage collection messages in minbuffer
(setq garbage-collection-messages t)

;;; always debug on error
(setq debug-on-error t)

;;; filename in titlebar
(setq frame-title-format
      (concat user-login-name "@" (system-name) ":%f [%m]"))

;;; C-x w h [REGEX] <RET> <RET> to highlight all occurances of [REGEX], and C-x w r [REGEX] <RET> to unhighlight them again.
(global-hi-lock-mode 1)

;;; personal init files
(use-package scwfri-defun
  :after evil
  :hook
  ;; server postfix for tramp editing
  (find-file-hook . $add-server-postfix)
  :bind (:map evil-normal-state-map
              ("_P" . $profile-session)
              ("u" . $simple-undo)
              ("C-r" . $simple-redo)))

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
(use-package yasnippet             :defer t)
(use-package inf-ruby              :defer t)
(use-package dired+                :defer 5)
(use-package bookmark+             :defer 5)

;;; base16-theme
;;(use-package base16-theme
;;  :config
;;  (load-theme 'base16-default-dark t))

;;; modus-theme
(use-package modus-themes
  :commands (modus-themes-load-themes)
  :init
  (setq modus-themes-slanted-constructs t
        modus-themes-bold-constructs nil)
  (modus-themes-load-themes)
  :config
  (modus-themes-load-vivendi)
  :bind
  ("C-c C-t" . modus-themes-toggle))

;;; evil
(use-package evil
  :init
  (setf evil-want-keybinding 'nil)
  :config
  ;; make evil words work like vim
  (defalias #'forward-evil-word #'forward-evil-symbol)
  (setq-default evil-symbol-word-search t)
  (setq evil-search-module 'evil-search)

  (setq evil-search-module 'evil-search)
  (setq evil-ex-complete-emacs-commands t)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  (setq evil-shift-round t)
  (setq-default evil-cross-lines t)
  (setq evil-want-C-u-scroll t)
  (evil-mode 1)

  (evil-ex-define-cmd "Q" 'evil-quit)
  (evil-ex-define-cmd "E" 'evil-edit)
  (evil-ex-define-cmd "W" 'evil-write)
  (evil-ex-define-cmd "vs" '$evil-split-right-and-move)
  (evil-ex-define-cmd "Vs" '$evil-split-right-and-move)

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

  :bind (
         :map evil-normal-state-map
         ("_w" . $toggle-show-trailing-whitespace)
         ("_f" . $show-full-file-path)

         ("\\w" . delete-trailing-whitespace)
         ("\\f" . find-name-dired)
         ("\\h" . highlight-symbol-at-point)
         ("\\H" . unhighlight-regexp)
         ("\\c" . global-hl-line-mode)
         ("\\C" . column-marker-1)
         ("\\pT" . list-tags)

         ("C-l" . evil-ex-nohighlight)
         ("C-j" . $evil-scroll-down-keep-pos)
         ("C-k" . $evil-scroll-up-keep-pos)
         ("C-u" . evil-scroll-up)

         ("j" . evil-next-visual-line)
         ("k" . evil-previous-visual-line)
         ("]b" . evil-next-buffer)
         ("[b" . evil-prev-buffer)
         ("gb" . evil-next-buffer)
         ("gB" . evil-prev-buffer)
         ("*" . $evil-star-keep-position)
         ("DEL" . evil-switch-to-windows-last-buffer)
         ("M-u" . universal-argument)

         :map evil-visual-state-map
         ("C-u" . evil-scroll-up)
         ("j" . evil-next-visual-line)
         ("k" . evil-previous-visual-line)
         ("gl" . align-regexp)
         ("TAB" . tab-to-tab-stop)
         ("C-u" . (lambda ()
                    (interactive)
                    (evil-delete (point-at-bol) (point))))

         :map universal-argument-map
         ("M-u" . universal-argument-more)
         ("C-u" . nil))
  :hook
  (python-mode-hook . (lambda ()
                        (setq evil-shift-width python-indent)))
  (ruby-mode-hook . (lambda ()
                      (setq evil-shift-width ruby-indent-level)))
  (org-mode-hook . (lambda ()
                     (setq evil-shift-width 1))))

;;; evil-owl
(use-package evil-owl
  :config
  (setq evil-owl-max-string-length 500)
  (setq evil-owl-header-format       "%s")
  (setq evil-owl-register-format     " %r: %s")
  (setq evil-owl-local-mark-format   " %m (%l:%c): %s")
  (setq evil-owl-global-mark-format  " %m [%b] (%l:%c): %s")
  (setq evil-owl-separator           "\n")
  (add-to-list 'display-buffer-alist
               '("*evil-owl*"
                 (display-buffer-in-side-window)
                 (side . bottom)
                 (window-height . 0.25)))
  (evil-owl-mode))

;;; evil-collection
(use-package evil-collection
  :after evil
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

;;; avy
(use-package avy
  :bind (("s-," . avy-goto-char-timer)
         :map evil-normal-state-map
         ("s" . avy-goto-char-timer)))

;;; plus-minus
(use-package plus-minus
  :demand t
  :bind
  (("C-c C-a"   . +/-:forward+)
   ("C-c C-x"   . +/-:forward-)
   ("C-c M-a"   . +/-:backward+)
   ("C-c M-x"   . +/-:backward-)
   ("C-c g C-a" . +/-:block+)
   ("C-c g C-x" . +/-:block-)))

;;; org-mode
(use-package org
  :commands (org-mode org-capture)
  :defer t
  :bind (("C-c l" . org-store-link)
         ("C-c a" . org-agenda)
         ("C-c c" . org-capture))
  :config
  (add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
  (setq org-hide-leading-stars t)
  (setq org-src-preserve-indentation nil
        org-edit-src-content-indentation 0)
  (setq org-todo-keywords
        '((sequence "TODO" "IN-PROGRESS" "WAITING" "DONE"))))

;;; org-bullets
(use-package org-bullets
  :commands org-bullets-mode
  :defer t
  :hook
  (org-mode-hook . (lambda () (org-bullets-mode 1))))

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
  :bind (;;("C-c f" . projectile-find-file)
         :map evil-normal-state-map
         ("\\pt" . projectile-find-tag)
         :map projectile-mode-map
         ("M-p" . projectile-command-map)
         ("C-c p" . projectile-command-map)))

;;;; orderless
(use-package orderless
  :custom (completion-styles '(orderless))
  :config
  (defun $orderless-flex (pattern _index _total)
    "TODO: add docstring (PATTERN _INDEX _TOTAL)."
    (when (string-suffix-p "~" pattern)
      `(orderless-flex . ,(substring pattern 0 -1))))

  (defun $orderless-initialism (pattern _index _total)
    "TODO: add docstring (PATTERN _INDEX _TOTAL)."
    (when (string-suffix-p "," pattern)
      `(orderless-initialism . ,(substring pattern 0 -1))))

  (defun $orderless-literal (pattern index _total)
    "TODO: add docstring (PATTERN _INDEX _TOTAL)."
    (when (string-suffix-p "=" pattern)
      `(orderless-literal . ,(substring pattern 0 -1))))

  (defun $orderless-regexp (pattern index _total)
    "TODO: add docstring (PATTERN _INDEX _TOTAL)."
    (when (string-suffix-p "/" pattern)
      `(orderless-regexp . ,(substring pattern 0 -1))))

  (defun $orderless-strict-leading-initialism (pattern index _total)
    "TODO: add docstring (PATTERN _INDEX _TOTAL)."
    (when (string-suffix-p "+" pattern)
      `(orderless-strict-leading-initialism . ,(substring pattern 0 -1))))

  (defun $orderless-without-literal (pattern _index _total)
    "TODO: add docstring (PATTERN _INDEX _TOTAL)."
    (when (string-prefix-p "!" pattern)
      `(orderless-without-literal . ,(substring pattern 1))))

  (setq orderless-matching-styles '(orderless-flex)
        orderless-style-dispatchers '($orderless-literal
                                      $orderless-strict-leading-initialism
                                      $orderless-initialism
                                      $orderless-regexp
                                      $orderless-flex
                                      $orderless-without-literal))
  (defun $match-components-literally ()
    "Components match literally for the rest of the session."
    (interactive)
    (setq-local orderless-matching-styles '(orderless-literal)
                orderless-style-dispatchers nil))

  (define-key minibuffer-local-completion-map (kbd "C-l")
    #'$match-components-literally)

  (setq selectrum-refine-candidates-function #'orderless-filter)
  (setq selectrum-highlight-candidates-function #'orderless-highlight-matches))

;;; marginalia
(use-package marginalia
  :bind (:map minibuffer-local-map
              ("C-M-a" . marginalia-cycle))
  :commands (marginalia-mode)
  :init
  (marginalia-mode)
  (setq marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil)))

;;; embark
(use-package embark
  :bind
  ("C-," . embark-act)
  :config
  (defun current-candidate+category ()
    (when selectrum-active-p
      (cons (selectrum--get-meta 'category)
            (selectrum-get-current-candidate))))
  (add-hook 'embark-target-finders #'current-candidate+category)

  (setq embark-action-indicator
        (lambda (map)
          (which-key--show-keymap "Embark" map nil nil 'no-paging)
          #'which-key--hide-popup-ignore-command)
        embark-become-indicator embark-action-indicator)

  (defun current-candidates+category ()
    (when selectrum-active-p
      (cons (selectrum--get-meta 'category)
            (selectrum-get-current-candidates
             ;; Pass relative file names for dired.
             minibuffer-completing-file-name))))

  :hook
  ;; No unnecessary computation delay after injection.
  (embark-setup-hook . selectrum-set-selected-candidate)
  (embark-candidate-collectors . current-candidates+category))

(use-package embark-consult
  :after (embark consult)
  :demand t
  :hook
  (embark-collect-mode . embark-consult-preview-minor-mode))

;;; selectrum
(use-package selectrum
  :commands (selectrum-mode)
  :init
  (selectrum-mode +1)
  :bind
  ("C-x C-z" . selectrum-repeat))

;;; consult
(use-package consult
  :bind (("C-s" . consult-line)
         ("C-x f" . consult-recent-file)
         ("C-x M-:" . consult-complex-command)
         ("C-c h" . consult-history)
         ("C-c m" . consult-mode-command)
         ("C-x b" . consult-buffer)
         ("C-x 4 b" . consult-buffer-other-window)
         ("C-x 5 b" . consult-buffer-other-frame)
         ("C-x r x" . consult-register)
         ("M-g g" . consult-goto-line)
         ("M-g M-g" . consult-goto-line)
         ("M-g o" . consult-outline)
         ("M-g l" . consult-line)
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g r" . consult-git-grep)
         ("M-g f" . consult-find)
         ("M-g i" . consult-project-imenu)
         ("M-g e" . consult-error)
         ("M-s m" . consult-multi-occur)
         ("M-y" . consult-yank-pop)
         ("<help> a" . consult-apropos)
         :map evil-normal-state-map
         ("\\\\" . consult-imenu)
         ("\\g" . consult-git-grep)
         ("\\pr" . consult-recent-file)
         ("\\pb" . consult-buffer)
         ("\\b" . consult-buffer)
         ("SPC" . consult-grep)
         ("gr" . consult-grep))

  :init
  ;; Replace `multi-occur' with `consult-multi-occur', which is a drop-in replacement.
  (fset 'multi-occur #'consult-multi-occur)

  ;; register preview setting
  (setq register-preview-delay 0
        register-preview-function #'consult-register-preview)

  :config
  ;; Configure preview. Note that the preview-key can also be configured on a
  ;; per-command basis via `consult-config'.
  ;; The default value is 'any, such that any key triggers the preview.
  ;;(setq consult-preview-key (kbd "M-q"))
  (setq consult-config `((consult-theme :preview-key (list ,(kbd "C-M-n") ,(kbd "C-M-p")))
                         (consult-buffer :preview-key ,(kbd "M-q"))))

  ;; configure narrowing key.
  (setq consult-narrow-key "C-+")
  ;; make narrowing help available in the minibuffer.
  (define-key consult-narrow-map (vconcat consult-narrow-key "?") #'consult-narrow-help)
  (autoload 'projectile-project-root "projectile")
  (setq consult-project-root-function #'projectile-project-root))

;; consult-selectrum
(use-package consult-selectrum
  :after selectrum
  :demand t)

;; consult-flycheck
(use-package consult-flycheck
  :bind (:map flycheck-command-map
              ("!" . consult-flycheck)))

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
  :hook
  (ffip-diff-mode-hook . ffip-diff-mode-hook-setup)
  :bind (("C-c f" . find-file-in-project)))

;;; smex
(use-package smex
  :disabled
  :commands (smex smex-initialize)
  :defer t
  :config
  (smex-initialize)
  :bind (("M-x" . smex)
         ("M-X" . smex-major-mode-commands)
         ("C-c C-c M-x" . execute-extended-command)))

;;; company
(use-package company
  :demand t
  :commands (global-company-mode company-mode company-indent-or-complete-common)
  :bind (:map company-active-map
              ("C-n" . company-select-next)
              ("C-p" . company-select-previous))
  :hook
  (after-init-hook . global-company-mode)
  :config
  (setq company-backends '((company-files company-keywords company-capf company-dabbrev-code company-etags company-dabbrev)))
  (global-company-mode 1))

;;; flycheck
(use-package flycheck
  :defer 5
  :commands (flycheck-mode global-flycheck-mode)
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
  :hook
  (elpy-mode-hook . flycheck-mode)
  (elpy-mode-hook . (lambda () (highlight-indentation-mode -1)))
  (python-mode-hook . (lambda()
                        (set (make-local-variable 'company-backends)
                             (list 'elpy-company-backend 'company-backends)))))

;;; slime
(use-package slime
  :defer t
  :commands (slime)
  :init
  (setq inferior-lisp-program "/usr/bin/sbcl")
  :config
  (slime-setup '(slime-fancy slime-company))
  (defun $slime-keybindings ()
    "keybindings for use in slime"
    (local-set-key (kbd "C-c e") 'slime-eval-last-expression)
    (local-set-key (kbd "C-c b") 'slime-eval-buffer))
  (add-hook 'slime-mode-hook #$slime-keybindings)
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
   (append auto-mode-alist interpreter-mode-alist))
   :config
   (setq cperl-invalid-face nil)
   (setq cperl-highlight-variables-indiscriminately t))

;;; projectile-rails
(use-package projectile-rails
  :defer t
  :commands (projectile-rails-mode projectile-rails-command-map)
  :bind (("C-c r" . projectile-rails-command-map))
  :config
  (projectile-rails-global-mode)
  :hook
  (ruby-mode-hook . projectile-rails-mode))

;;; dumb-jump
(use-package dumb-jump
  :defer 5
  :commands (dumb-jump-go)
  :config
  (add-to-list 'xref-backend-functions 'dumb-jump-xref-activate t)
  ;; Preserve jump list in evil
  (defun evil-set-jump-args (&rest ns) (evil-set-jump))
  (advice-add 'dumb-jump-goto-file-line :before #'evil-set-jump-args))

;;; uniquify
(use-package uniquify
  :custom
  (uniquify-buffer-name-style 'forward)
  (uniquify-separator "/")
  ;; rename after killing unqualified
  (uniquify-after-kill-buffer-p t)
  ;; dont change names of special buffers
  (uniquify-ignore-buffers-re "^\\*"))

;;; display-buffer (most/all of this taken from prot)
(use-package window
  :init
  (setq display-buffer-alist
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
           (display-buffer-in-side-window)
           (window-width . 0.25)       ; See the :hook
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
           (window-width . 0.25)
           (side . right)
           (slot . 1)
           (window-parameters . ((no-other-window . t))))
          ;; bottom buffer (NOT side window)
          ("\\*\\vc-\\(incoming\\|outgoing\\).*"
           (display-buffer-at-bottom))
          ("\\*\\(Output\\|Register Preview\\).*"
           (display-buffer-at-bottom)
           (window-parameters . ((no-other-window . t))))
          ("\\*.*\\([^E]eshell\\|shell\\|v?term\\).*"
           (display-buffer-reuse-mode-window display-buffer-at-bottom)
           (window-height . 0.25))))
  (setq window-combination-resize t)
  (setq even-window-sizes 'height-only)
  (setq window-sides-vertical nil)
  (setq switch-to-buffer-in-dedicated-window 'pop)
  :hook ((help-mode-hook . visual-line-mode)
         (custom-mode-hook . visual-line-mode))
  :bind (("s-n" . next-buffer)
         ("s-p" . previous-buffer)
         ("s-o" . other-window)
         ("s-2" . split-window-below)
         ("s-3" . split-window-right)
         ("s-0" . delete-window)
         ("s-1" . delete-other-windows)
         ("s-!" . delete-other-windows-vertically) ; s-S-1
         ("s-5" . delete-frame)
         ("C-x _" . balance-windows)
         ("C-x +" . balance-windows-area)
         ("s-q" . window-toggle-side-windows)))

;;; winner-mode
(use-package winner
  :hook
  (after-init-hook . winner-mode)
  :bind(("<s-right>" . winner-redo)
        ("<s-left>" . winner-undo)))

;;; windmove
(use-package windmove
  :config
  (setq windmove-create-window nil)
  :bind (("C-c <up>" . windmove-up)
         ("C-c <down>" . windmove-down)
         ("C-c <left>" . windmove-left)
         ("C-c <right>" . windmove-right)))

;;; tab-bar (again, most/all of this taken from prot)
(use-package tab-bar
  :init
  (setq tab-bar-close-button-show nil)
  (setq tab-bar-close-last-tab-choice 'tab-bar-mode-disable)
  (setq tab-bar-close-tab-select 'recent)
  (setq tab-bar-new-tab-choice t)
  (setq tab-bar-new-tab-to 'right)
  (setq tab-bar-position nil)
  (setq tab-bar-show nil)
  (setq tab-bar-tab-hints nil)
  (setq tab-bar-tab-name-function 'tab-bar-tab-name-all)

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
         ("s-t" . $tab-select-tab-dwim)
         :map evil-normal-state-map
         ("]t" . tab-next)
         ("[t" . tab-previous)))


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
  (prog-mode-hook . idle-highlight-mode)
  :bind (:map evil-normal-state-map
              ("_h" . idle-highlight-mode)))

;;; column-marker
(use-package column-marker)

;;; hl-todo
(use-package hl-todo
  :hook (prog-mode-hook . hl-todo-mode)
  :config
  (setq hl-todo-keyword-faces
        '(("TODO"   . "#FFFF00")
          ("FIXME"  . "#FFFF00")
          ("DEBUG"  . "#00FFFF")))
  :bind (:map hl-todo-mode-map
              ("C-c t p" . hl-todo-previous)
              ("C-c t n" . hl-todo-next)
              ("C-c t o" . hl-todo-occur)
              ("C-c t i" . hl-todo-insert)
              :map evil-normal-state-map
              ("\\t" . hl-todo-occur)))

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
  (setq delete-old-versions -1)
  (setq version-control t)
  (setq vc-make-backup-files t)

  ;; history settings
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

;;; restart-emacs
(use-package restart-emacs)

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
