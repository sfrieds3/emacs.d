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
  (require 'use-package)
  ;; do not add -hook suffix automatically in use-package :hook
  (setq use-package-hook-name-suffix nil))

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

;;; set up use-package

;;; personal init files
(use-package scwfri-defun
  :config
  ;; server postfix for tramp editing
  :hook
  (find-file-hook . $add-server-postfix))

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
  ;; make evil words work like vim
  (defalias #'forward-evil-word #'forward-evil-symbol)
  (setq-default evil-symbol-word-search t)
  (setq evil-search-module 'evil-search)

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
  (define-key evil-normal-state-map (kbd "\\g") 'consult-git-grep)
  (define-key evil-normal-state-map (kbd "\\h") 'highlight-symbol-at-point)
  (define-key evil-normal-state-map (kbd "\\H") 'unhighlight-regexp)
  (define-key evil-normal-state-map (kbd "\\c") 'global-hl-line-mode)
  (define-key evil-normal-state-map (kbd "\\C") 'column-marker-1)
  (define-key evil-normal-state-map (kbd "\\\\") 'consult-imenu)
  (define-key evil-normal-state-map (kbd "\\pt") 'projectile-find-tag)
  (define-key evil-normal-state-map (kbd "\\pT") 'list-tags)
  (define-key evil-normal-state-map (kbd "\\pr") 'consult-recent-file)
  (define-key evil-normal-state-map (kbd "\\pb") 'consult-buffer)

  ;; other

  (define-key evil-normal-state-map (kbd "C-r") '$simple-redo)
  (define-key evil-normal-state-map (kbd "C-l") 'evil-ex-nohighlight)
  (define-key evil-normal-state-map (kbd "C-j") '$evil-scroll-down-keep-pos)
  (define-key evil-normal-state-map (kbd "C-k") '$evil-scroll-up-keep-pos)
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

;;; orderless
(use-package orderless
  :custom (completion-styles '(orderless))
  :config
  (defun flex-if-twiddle (pattern _index _total)
    (when (string-suffix-p "~" pattern)
      `(orderless-flex . ,(substring pattern 0 -1))))

  ;;(defun first-initialism (pattern index _total)
  ;;  (if (= index 0) 'orderless-initialism))

  (defun without-if-bang (pattern _index _total)
    (when (string-prefix-p "!" pattern)
      `(orderless-without-literal . ,(substring pattern 1))))

  (setq orderless-matching-styles '(orderless-regexp)
        orderless-style-dispatchers '(;;first-initialism
                                      flex-if-twiddle
                                      without-if-bang))
  (setq selectrum-refine-candidates-function #'orderless-filter)
  (setq selectrum-highlight-candidates-function #'orderless-highlight-matches))

;;; marginalia
(use-package marginalia
  :bind (:map minibuffer-local-map
              ("C-M-a" . marginalia-cycle)
              ("A" . marginalia-cycle))
  :commands (marginalia-mode)
  :init
  (marginalia-mode)

  ;; When using Selectrum, ensure that Selectrum is refreshed when cycling annotations.
  (advice-add #'marginalia-cycle :after
              (lambda () (when (bound-and-true-p selectrum-mode) (selectrum-exhibit))))

  ;; Prefer richer, more heavy, annotations over the lighter default variant.
  ;; E.g. M-x will show the documentation string additional to the keybinding.
  ;; By default only the keybinding is shown as annotation.
  ;; Note that there is the command `marginalia-cycle' to
  ;; switch between the annotators.
  (setq marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil)))

;;; embark
(use-package embark
  :bind
  ("C-S-a" . embark-act)               ; pick some comfortable binding
  :config
  ;; For Selectrum users:
  (defun current-candidate+category ()
    (when selectrum-active-p
      (cons (selectrum--get-meta 'category)
            (selectrum-get-current-candidate))))

  (add-hook 'embark-target-finders #'current-candidate+category)

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

;;; selectrum
(use-package selectrum
  :commands (selectrum-mode)
  :init
  (selectrum-mode +1)
  :bind
  ("C-x C-z" . selectrum-repeat))

;;; consult
(use-package consult
  ;; Replace bindings. Lazily loaded due by `use-package'.
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
         ("M-g o" . consult-outline)       ;; "M-s o" is a good alternative.
         ("M-g l" . consult-line)          ;; "M-s l" is a good alternative.
         ("M-g m" . consult-mark)          ;; I recommend to bind Consult navigation
         ("M-g k" . consult-global-mark)   ;; commands under the "M-g" prefix.
         ("M-g r" . consult-git-grep)      ;; or consult-grep, consult-ripgrep
         ("M-g f" . consult-find)          ;; or consult-locate, my-fdfind
         ("M-g i" . consult-project-imenu) ;; or consult-imenu
         ("M-g e" . consult-error)
         ("M-s m" . consult-multi-occur)
         ("M-y" . consult-yank-pop)
         ("<help> a" . consult-apropos))

  :init
  ;; Custom command wrappers. It is generally encouraged to write your own
  ;; commands based on the Consult commands. Some commands have arguments which
  ;; allow tweaking. Furthermore global configuration variables can be set
  ;; locally in a let-binding.
  (defun my-fdfind (&optional dir)
    (interactive "P")
    (let ((consult-find-command '("fdfind" "--color=never" "--full-path")))
      (consult-find dir)))

  ;; Replace `multi-occur' with `consult-multi-occur', which is a drop-in replacement.
  (fset 'multi-occur #'consult-multi-occur)

  ;; register preview setting
  (setq register-preview-delay 0
        register-preview-function #'consult-register-preview)

  ;; Configure other variables and modes in the :config section, after lazily loading the package
  :config
  ;; Configure preview. Note that the preview-key can also be configured on a
  ;; per-command basis via `consult-config'.
  ;; The default value is 'any, such that any key triggers the preview.
  ;;(setq consult-preview-key (kbd "M-p"))
  (setq consult-config `((consult-theme :preview-key (list ,(kbd "C-M-n") ,(kbd "C-M-p)))
                       (consult-buffer :preview-key ,(kbd "M-p"))))

  ;; Optionally configure narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; (kbd "C-+")
  ;; Optionally make narrowing help available in the minibuffer.
  ;; Probably not needed if you are using which-key.
  ;; (define-key consult-narrow-map (vconcat consult-narrow-key "?") #'consult-narrow-help)

  ;; Optional configure a view library to be used by `consult-buffer'.
  ;; The view library must provide two functions, one to open the view by name,
  ;; and one function which must return a list of views as strings.
  ;; Example: https://github.com/minad/bookmark-view/
  ;; (setq consult-view-open-function #'bookmark-jump
  ;;       consult-view-list-function #'bookmark-view-names)

  ;; Optionally configure a function which returns the project root directory
  (autoload 'projectile-project-root "projectile")
  (setq consult-project-root-function #'projectile-project-root))

;; Enable Consult-Selectrum integration.
;; This package should be installed if Selectrum is used.
(use-package consult-selectrum
  :after selectrum
  :demand t)

;; Optionally add the `consult-flycheck' command.
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
  :commands (projectile-rails-mode projectile-rails-command-map)
  :bind (("C-c r" . projectile-rails-command-map))
  :config
  (projectile-rails-global-mode)
  :hook
  (ruby-mode-hook . projectile-rails-mode))

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

;;; winner-mode
(use-package winner
  :config
  (winner-mode 1))

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
  (prog-mode-hook . idle-highlight-mode))

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
  (define-key hl-todo-mode-map (kbd "C-c p") 'hl-todo-previous)
  (define-key hl-todo-mode-map (kbd "C-c n") 'hl-todo-next)
  (define-key hl-todo-mode-map (kbd "C-c o") 'hl-todo-occur)
  (define-key hl-todo-mode-map (kbd "C-c i") 'hl-todo-insert))

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
