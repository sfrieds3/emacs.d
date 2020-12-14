;;;; package --- summary

;;; Commentary:
;;;     slime-config

;;; Code:

(require 'slime-autoloads)
(setq inferior-lisp-program "/usr/bin/sbcl")
(setq slime-contribs '(slime-fancy))
;; slime key bindings
(defun my/slime-keybindings ()
  "keybindings for use in slime"
  (local-set-key (kbd "C-c e") 'slime-eval-last-expression)
  (local-set-key (kbd "C-c b") 'slime-eval-buffer))
(add-hook 'slime-mode-hook #'my/slime-keybindings)
(add-hook 'slime-repl-mode-hook #'my/slime-keybindings)

(provide 'slime-config)
;;; slime-config.el ends here