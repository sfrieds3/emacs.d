;;;; package --- summary

;;; Commentary:
;;;     evil-config

;;; Code:

(setf evil-want-keybinding 'nil)
(require 'evil)
(require 'evil-numbers)
(require 'evil-collection)
(evil-mode 1)
(evil-collection-init)

(defun $clear-highlights ()
  "Clear highlight from evil-search."
  (interactive)
  (evil-ex "nohl")
  (exit-minibuffer))

(defun $star-keep-position ()
  "Keep position when searching."
  (interactive)
  (evil-search-word-forward)
  (evil-search-previous))

(defun $visualstar-keep-position ()
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

(defun $split-right-and-move ()
  "Split window to the right and move to it."
  (interactive)
  (split-window-right)
  (evil-window-right 1))

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
    (setq-default evil-cross-lines t)
    ;;(evil-select-search-module 'evil-search-module 'evil-search)
    (define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
    (define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)
    (define-key evil-normal-state-map (kbd "u") '$simple-undo)
    (define-key evil-normal-state-map (kbd "C-r") '$simple-redo)
    (define-key evil-normal-state-map (kbd "C-l") 'evil-ex-nohighlight)
    (define-key evil-normal-state-map (kbd "C-]") 'dumb-jump-go)
    (define-key evil-normal-state-map (kbd "\\w") 'delete-trailing-whitespace)
    (define-key evil-normal-state-map (kbd "\\f") 'find-name-dired)
    (define-key evil-normal-state-map (kbd "\\b") 'buffer-menu)
    (define-key evil-normal-state-map (kbd "DEL") 'evil-switch-to-windows-last-buffer)
    (define-key evil-normal-state-map (kbd "C-c +") 'evil-numbers/inc-at-pt)
    (define-key evil-normal-state-map (kbd "C-c -") 'evil-numbers/dec-at-pt)
    (define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)
    ;;(define-key evil-normal-state-map (kbd "*") '$star-keep-position)
    (define-key evil-normal-state-map (kbd "]b") 'evil-next-buffer)
    (define-key evil-normal-state-map (kbd "[b") 'evil-prev-buffer)
    (define-key evil-visual-state-map (kbd "C-u") 'evil-scroll-up)
    (define-key evil-visual-state-map (kbd "j") 'evil-next-visual-line)
    (define-key evil-visual-state-map (kbd "k") 'evil-previous-visual-line)
    ;;(define-key evil-visual-state-map (kbd "*") '$visualstar-keep-position)
    (define-key evil-insert-state-map (kbd "C-u")
      (lambda ()
        (interactive)
        (evil-delete (point-at-bol) (point))))
    (define-key evil-normal-state-map (kbd "_") 'universal-argument)
    (evil-ex-define-cmd "Q" 'evil-quit)
    (evil-ex-define-cmd "E" 'evil-edit)
    (evil-ex-define-cmd "W" 'evil-write)
    (evil-ex-define-cmd "vs" '$split-right-and-move)
    (evil-ex-define-cmd "Vs" '$split-right-and-move)
    (define-key universal-argument-map (kbd "_") 'universal-argument-more)
    (define-key universal-argument-map (kbd "C-u") nil)))
 

(provide 'evil-config)
;;; evil-config.el ends here
