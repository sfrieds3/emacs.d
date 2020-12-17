;;;; package --- summary

;;; Commentary:
;;;     evil-config

;;; Code:

(require 'evil)
(require 'evil-numbers)
(evil-mode 1)

(defun my/clear-highlights ()
  "Clear highlights from evil-search"
  (interactive)
  (evil-ex "nohl")
  (exit-minibuffer))

(defun my/star-keep-position ()
  (interactive)
  (case evil-search-module
    (evil-search (progn
                  (evil-ex-search-word-forward)
                  (evil-ex-search-previous)))
    (isearch (progn
               (evil-search-word-forward)
               (evil-search-previous)))))

(defun my/visualstar-keep-position ()
  (interactive)
  (when (region-active-p)
    (evil-visualstar/begin-search (region-beginning) (region-end) t)
    (case evil-search-module
      (evil-search (evil-ex-search-previous))
      (isearch (evil-search-previous)))))

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
    (evil-select-search-module 'evil-search-module 'evil-search)
    (define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
    (define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)
    (define-key evil-normal-state-map (kbd "u") 'my/simple-undo)
    (define-key evil-normal-state-map (kbd "C-r") 'my/simple-redo)
    (define-key evil-normal-state-map (kbd "C-l") 'evil-ex-nohighlight)
    (define-key evil-normal-state-map (kbd "\\w") 'delete-trailing-whitespace)
    (define-key evil-normal-state-map (kbd "\\f") 'find-name-dired)
    (define-key evil-normal-state-map (kbd "\\b") 'buffer-menu)
    (define-key evil-normal-state-map (kbd "DEL") 'evil-switch-to-windows-last-buffer)
    (define-key evil-normal-state-map (kbd "C-c +") 'evil-numbers/inc-at-pt)
    (define-key evil-normal-state-map (kbd "C-c -") 'evil-numbers/dec-at-pt)
    (define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)
    (define-key evil-normal-state-map (kbd "*") 'my/star-keep-position)
    (define-key evil-normal-state-map (kbd "]b") 'evil-next-buffer)
    (define-key evil-normal-state-map (kbd "[b") 'evil-prev-buffer)
    (define-key evil-visual-state-map (kbd "C-u") 'evil-scroll-up)
    (define-key evil-visual-state-map (kbd "j") 'evil-next-visual-line)
    (define-key evil-visual-state-map (kbd "k") 'evil-previous-visual-line)
    (define-key evil-visual-state-map (kbd "*") 'my/star-keep-position)
    (define-key evil-insert-state-map (kbd "C-u")
      (lambda ()
        (interactive)
        (evil-delete (point-at-bol) (point))))
    (define-key evil-normal-state-map (kbd "_") 'universal-argument)
    (evil-ex-define-cmd "Q" 'evil-quit)
    (evil-ex-define-cmd "E" 'evil-edit)
    (evil-ex-define-cmd "W" 'evil-write)
    (define-key universal-argument-map (kbd "_") 'universal-argument-more)
    (define-key universal-argument-map (kbd "C-u") nil)))
 

(provide 'evil-config)
;;; evil-config.el ends here
