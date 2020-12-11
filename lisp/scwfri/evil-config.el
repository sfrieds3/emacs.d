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
    (setq-default evil-cross-lines t)
    (define-key evil-normal-state-map "u" 'my/simple-undo)
    (define-key evil-normal-state-map "\C-r" 'my/simple-redo)
    (define-key evil-normal-state-map "\\w" 'delete-trailing-whitespace)
    (define-key evil-normal-state-map "\\RET" 'lazy-highlight-cleanup)
    (define-key evil-normal-state-map "\\f" 'find-name-dired)
    (define-key evil-normal-state-map "\\b" 'buffer-menu)
    (define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)
    (define-key evil-visual-state-map (kbd "C-u") 'evil-scroll-up)
    (define-key evil-insert-state-map (kbd "C-u")
      (lambda ()
        (interactive)
        (evil-delete (point-at-bol) (point)))))) 

(provide 'evil-config)
