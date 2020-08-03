;;;; package --- summary


;;; Commentary:
;;;     place 'local-settings.el' file (provide 'local-settings)
;;;     in .emacs.d directory to overwrite settings (loaded at end)

;;; Code:
;;;; GENERAL PACKAGE SETTINGS

(let ((default-directory  "~/.emacs.d/lisp/"))
  (normal-top-level-add-to-load-path '("."))
  (normal-top-level-add-subdirs-to-load-path))

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/emacs-theme-gruvbox")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/vscode-dark-plus-emacs-theme/")

;; backup settings
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq delete-old-versions -1)
(setq version-control t)
(setq vc-make-backup-files t)
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list" t)))

;; history settings
(setq savehist-file "~/.emacs.d/savehist")
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

;; byte recompile everything
;;(byte-recompile-directory (expand-file-name "~/.emacs.d/lisp") 0)

;; ////////////////////////////////////////////////////////////

;;;; THEME SETTINGS

;; ////////////////////////////////////////////////////////////

;; set default preferred fonts
(defvar platform-default-font)
(setq platform-default-font
      (cond ((eq system-type 'windows-nt) "DejaVu Sans Mono 10")
            ((eq system-type 'gnu/linux) "DejaVu Sans Mono 11")
            (t nil)))

(when platform-default-font
  (set-frame-font platform-default-font nil t))

(load-theme 'gruvbox-dark-hard t)

;; ////////////////////////////////////////////////////////////

;;;; STARTUP SETTINGS

;; ////////////////////////////////////////////////////////////

;; start emacsclient if server not running already

(load "server")
(unless (server-running-p) (server-start))

;; make scrolling work like it should
(setq scroll-step 1)
(setq scroll-conservatively 10000)
(setq auto-window-vscroll nil)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
(setq mouse-wheel-progressive-speed nil)
(setq mouse-wheel-follow-mouse 't)

;; cursor always blinks
(setq blink-cursor-blinks -1)

;; visuals
(setq inhibit-startup-screen t)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)

;; inhibit visual bells
(setq visible-bell nil
      ring-bell-function #'ignore)

;; highlight current line
(global-hl-line-mode -1)
(defvar hl-line-face)
(set-face-attribute hl-line-face nil :underline nil)

;; spaces by default instead of tabs!
(setq-default indent-tabs-mode nil)

;; show matching parens
(show-paren-mode 1)

;; smart parens
(electric-pair-mode -1)
;; dont use smart parens in mini-buffers
(defun my-inhibit-electric-pair-mode (char)
  (minibufferp))

(setq electric-pair-inhibit-predicate #'my-inhibit-electric-pair-mode)

;; turn on recent file mode
(recentf-mode t)
(setq recentf-max-saved-items 50)

;; filename in titlebar
(setq frame-title-format
      (concat "%f@" system-name))

;; C-x w h [REGEX] <RET> <RET> to highlight all occurances of [REGEX], and C-x w r [REGEX] <RET> to unhighlight them again.
(global-hi-lock-mode 1)

;; stop asking about upcase and downcase region
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;; advanced management of rectangles
;; C-RET to mark a corner
;; M-r to do revexp replace within marked rectange
;; C-RET to unmark/exit rectangle editing
(cua-selection-mode 1)

;; transient mark mode
(transient-mark-mode 1)

;; ////////////////////////////////////////////////////////////

;; PERSONAL FUNCTIONS

;; ////////////////////////////////////////////////////////////

;; mode line
(setq-default mode-line-format
              (list
               ;; file status info
               mode-line-mule-info
               mode-line-modified
               mode-line-frame-identification
               ;; current buffer name
               "%b |"
               ;; current git branch
               '(vc-mode vc-mode)
               ;; mode-name
               " [%m] "
               ;; current line and column number
               "(%l:%c %P)"
               ))

;; grep in current directory
(defun my/dir-grep ()
  "Run grep recursively from the directory of the current buffer or the default directory."
  (interactive)
  (let ((dir (file-name-directory (or load-file-name buffer-file-name default-directory))))
    (let ((command (read-from-minibuffer "Run grep (like this): "
                                         (cons (concat "grep --color --null -nH -ir -e  " dir) 32))))
      (grep command))))

;; grep in current file
(defun my/file-grep ()
  "Run grep in the current file."
  (interactive)
  (let ((fname (buffer-file-name)))
    (let ((command (read-from-minibuffer "Run grep (like this): "
                                         (cons (concat "grep --color --null -nH -ir -e  " fname) 32))))
      (grep command))))

;; revert file without prompt
(defun my/revert-buffer-noconfirm ()
  "Call `revert-buffer' with the NOCONFIRM argument set."
  (interactive)
  (revert-buffer nil t))

(defun my/ido-open-recentf ()
  "Use `ido-completing-read' to \\[find-file] a recent file"
  (interactive)
  (if (find-file (ido-completing-read "Find recent file: " recentf-list))
      (message "Opening file...")
    (message "Aborting")))

(defun my/smarter-move-beginning-of-line (arg)
  "Move point back to indentation of beginning of line.

  Move point to the first non-whitespace character on this line.
  If point is already there, move to the beginning of the line.
  Effectively toggle between the first non-whitespace character and
  the beginning of the line.

  If ARG is not nil or 1, move forward ARG - 1 lines first.  If
  point reaches the beginning or end of the buffer, stop there."
  (interactive "^p")
  (setq arg (or arg 1))

  ;; Move lines first
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))

  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))

(defun my/goto-match-paren (arg)
  "Go to the matching parenthesis if on parenthesis, otherwise insert %.
vi style of % jumping to matching brace."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1))
        ((looking-back "\\s\)") (backward-list 1))
        (t (self-insert-command (or arg 1)))))

(define-key isearch-mode-map (kbd "<C-return>")
  (defun my/isearch-done-opposite (&optional nopush edit)
    "End current search in the opposite side of the match."
    (interactive)
    (funcall #'isearch-done nopush edit)
    (when isearch-other-end (goto-char isearch-other-end))))

(defun my/kill-back-to-indent ()
  "Kill from point back to the first non-whitespace character on the line."
  (interactive)
  (let ((prev-pos (point)))
    (my/smarter-move-beginning-of-line nil)
    (kill-region (point) prev-pos)))

(defun my/select-line ()
  "Select entire line"
  (interactive)
  (beginning-of-line)
  (cua-set-mark)
  (end-of-line))

(defun my/delete-trailing-whitespace ()
  "Delete trailing whitespace, and echo"
  (interactive)
  (delete-trailing-whitespace)
  (message "trailing whitespace deleted..."))

 ;; ////////////////////////////////////////////////////////////

;; EVIL CONFIG

;; ////////////////////////////////////////////////////////////

;; evil mode
(require 'evil)
(evil-mode 1)
;; evil bindings for occur mode
(add-hook 'occur-mode-hook
          (lambda ()
            (evil-add-hjkl-bindings occur-mode-map 'emacs
              (kbd "/")       'evil-search-forward
              (kbd "n")       'evil-search-next
              (kbd "N")       'evil-search-previous
              (kbd "C-d")     'evil-scroll-down
              (kbd "C-u")     'evil-scroll-up
              (kbd "C-w C-w") 'other-window)))
(eval-after-load 'evil
  (progn
    (defalias #'forward-evil-word #'forward-evil-symbol)
    ;; make evil-search-word look for symbol rather than word boundaries
    (setq-default evil-symbol-word-search t)
    ;; Make horizontal movement cross lines
    (setq-default evil-cross-lines t)))

(require 'general)
(general-evil-define-key 'normal 'global
                         :prefix "SPC"
                         "SPC" 'other-window
                         "W" 'delete-trailing-whitespace
                         "RET" 'lazy-highlight-cleanup
                         "h" 'dired-jump)

;; ////////////////////////////////////////////////////////////

;; SMEX/IDO STUFF

;; ////////////////////////////////////////////////////////////

(icomplete-mode 1)
(setq icomplete-hide-common-prefix nil)
(setq icomplete-show-matches-on-no-input t)
(setq icomplete-in-buffer t)

(ido-mode 1)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(setq ido-use-filename-at-point 'guess)
(setq ido-cannot-complete-command 'ido-next-match)

;; fix keymap for ido completion
(defun my/ido-keys ()
  "Add my keybindings for ido."
  (define-key ido-completion-map (kbd "C-.") 'ido-next-match)
  (define-key ido-completion-map (kbd "C-,") 'ido-prev-match)
  (define-key ido-completion-map (kbd "C-n") 'ido-next-match)
  (define-key ido-completion-map (kbd "C-p") 'ido-prev-match)
  (define-key ido-completion-map (kbd "<backtab") 'ido-prev-match)
  (define-key ido-completion-map (kbd "<tab>") 'ido-exit-minibuffer)
  (define-key ido-completion-map (kbd "C-e") 'ido-exit-minibuffer))

(add-hook 'ido-setup-hook #'my/ido-keys)

;; ////////////////////////////////////////////////////////////

;; ORG MODE

;; ////////////////////////////////////////////////////////////

(require 'org)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))

(setq org-todo-keywords
      '((sequence "TODO" "IN-PROGRESS" "WAITING" "DONE")))

;; keybindings
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)

;; ////////////////////////////////////////////////////////////

;; PACKAGES

;; ////////////////////////////////////////////////////////////

(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
(define-key company-active-map (kbd "C-n") 'company-select-next-or-abort)
(define-key company-active-map (kbd "C-p") 'company-select-previous-or-abort)

(add-hook 'python-mode-hook
          (lambda ()
            (add-to-list (make-local-variable 'company-backends)
                         'elpy-company-backend)))

(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)
(setq uniquify-separator "/")
(setq uniquify-after-kill-buffer-p t) ;; rename after killing uniquified
(setq uniquify-ignore-buffers-re "^\\*") ;; dont change names of special buffers.

;; elpy
(add-to-list 'load-path "~/.emacs.d/lisp/elpy")
(load "elpy")
(load "elpy-rpc")
(load "elpy-shell")
(load "elpy-profile")
(load "elpy-refactor")
(load "elpy-django")
(elpy-enable)
(setq elpy-rpc-python-command "python3")

(require 'slime)
(custom-set-faces
'(slime-repl-inputed-output-face ((t (:foreground "yellow")))))

;; ////////////////////////////////////////////////////////////

;;;; LANGUAGE SETTINGS AND PACKAGES

;; ////////////////////////////////////////////////////////////

;; c++
(defun my/c++-mode-hook ()
  "C++ mode stuff."
  (defvar c-basic-offset)
  (setq c-basic-offset 4)
  (c-set-offset 'substatement-open 0))
(add-hook 'c++-mode-hook 'my/c++-mode-hook)

;; eldoc mode
(add-hook 'emacs-lisp-mode-hook 'eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'eldoc-mode)
(add-hook 'ielm-mode-hook 'eldoc-mode)

;; ////////////////////////////////////////////////////////////

;;;; GENERAL KEY REMAPPINGS

;; ////////////////////////////////////////////////////////////

;; move between windows with shift-arrow keys
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

;; custom functions
(global-set-key (kbd "C-c s d") 'my/dir-grep)
(global-set-key (kbd "C-c s s") 'my/file-grep)
(global-set-key (kbd "C-c s f") 'find-dired)
(global-set-key (kbd "C-x f") 'my/ido-open-recentf)
(global-set-key (kbd "C-a") 'my/smarter-move-beginning-of-line)
(global-set-key (kbd "C-<tab>") 'my/goto-match-paren)
(global-set-key (kbd "%") 'my/goto-match-paren)

;; SPC commands
(global-set-key (kbd "C-c SPC l") 'my/select-line)
(global-set-key (kbd "C-c SPC r") 'replace-regexp)
(global-set-key (kbd "C-c SPC i") 'indent-region)
(global-set-key (kbd "C-c SPC W") 'my/delete-trailing-whitespace)
(global-set-key (kbd "C-c SPC l") 'goto-line)
(global-set-key (kbd "C-c SPC b e") 'eval-buffer)
(global-set-key (kbd "C-c SPC b r") 'revert-buffer)

;; general customizations
(global-set-key (kbd "C-c [") 'previous-error)
(global-set-key (kbd "C-c ]") 'next-error)
(global-set-key (kbd "C-c o") 'occur)
(global-set-key (kbd "C-c O") 'multi-occur-in-matching-buffers)
(global-set-key (kbd "C-c e") 'eval-defun)
(global-set-key (kbd "C-c r") 'recentf-open-files)
(global-set-key (kbd "C-x C-b") 'buffer-menu-other-window)

;; window management
(global-set-key (kbd "C-S-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "C-S-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "C-S-<down>") 'shrink-window)
(global-set-key (kbd "C-S-<up>") 'enlarge-window)
(global-set-key (kbd "C-c D") 'delete-window)
(global-set-key (kbd "M-o") 'other-window)

;; hippie expand -- also C-M-i for completion mode
(global-set-key (kbd "C-.") 'hippie-expand)

;; string insert region
(global-set-key (kbd "C-c I") 'string-insert-rectangle)

;; indent
(global-set-key (kbd "C-x TAB") 'indent-code-rigidly)
(global-set-key (kbd "C-M-<backspace>") 'my/kill-back-to-indent)

;; want to go to correct indentation on enter
(global-set-key (kbd "RET") 'newline-and-indent)

;; no C-z
(global-set-key (kbd "C-z") nil)

;; version control
(global-set-key (kbd "C-c g \\") 'vc-diff)
(global-set-key (kbd "C-c g h") 'vc-region-history)
(global-set-key (kbd "C-c g s") 'vc-dir)

;; ////////////////////////////////////////////////////////////

;; platform specific files

;; ////////////////////////////////////////////////////////////

(let ((local-settings (expand-file-name "local-settings.el" user-emacs-directory)))
  (when (file-exists-p local-settings)
    (load-file local-settings)))

;; ////////////////////////////////////////////////////////////

(provide 'init.el)
