(require 'evil)
(evil-mode 1)
(require 'undo-tree)
(global-undo-tree-mode)
(setq evil-want-fine-undo 'fine)

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
    (define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)
    (define-key evil-visual-state-map (kbd "C-u") 'evil-scroll-up)
    (define-key evil-insert-state-map (kbd "C-u")
      (lambda ()
        (interactive)



(provide 'evil-config)
