;;;; package --- summary

;;; Commentary:
;;;     evil-config

;;; Code:

(require 'evil)
(require 'evil-numbers)
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
    (setq-default evil-cross-lines t)
    (define-key evil-normal-state-map (kbd "u") 'my/simple-undo)
    (define-key evil-normal-state-map (kbd "C-r") 'my/simple-redo)
    (define-key evil-normal-state-map (kbd "C-l") 'lazy-highlight-cleanup)
    (define-key evil-normal-state-map (kbd "\\w") 'delete-trailing-whitespace)
    (define-key evil-normal-state-map (kbd "\\f") 'find-name-dired)
    (define-key evil-normal-state-map (kbd "\\b") 'buffer-menu)
    (define-key evil-normal-state-map (kbd "DEL") 'evil-switch-to-windows-last-buffer)
    (define-key evil-normal-state-map (kbd "C-c +") 'evil-numbers/inc-at-pt)
    (define-key evil-normal-state-map (kbd "C-c -") 'evil-numbers/dec-at-pt)
    (define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)
    (define-key evil-visual-state-map (kbd "C-u") 'evil-scroll-up)
    (define-key evil-insert-state-map (kbd "C-u")
      (lambda ()
        (interactive)
        (evil-delete (point-at-bol) (point))))
    (define-key evil-normal-state-map (kbd "_") 'universal-argument)
    (define-key universal-argument-map (kbd "_") 'universal-argument-more)
    (define-key universal-argument-map (kbd "C-u") nil)))
 

(provide 'evil-config)
;;; evil-config.el ends here
