;;;; package --- summary

;;; Commentary:
;;;     ido-config

;;; Code:

(ido-mode 1)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(setq ido-use-filename-at-point 'guess)
(setq ido-cannot-complete-command 'ido-next-match)

;; fix keymap for ido completion
(defun $ido-keys ()
  "Add my keybindings for ido."
  (define-key ido-completion-map (kbd "C-.") 'ido-next-match)
  (define-key ido-completion-map (kbd "C-,") 'ido-prev-match)
  (define-key ido-completion-map (kbd "C-n") 'ido-next-match)
  (define-key ido-completion-map (kbd "C-p") 'ido-prev-match)
  (define-key ido-completion-map (kbd "<backtab") 'ido-prev-match)
  (define-key ido-completion-map (kbd "<tab>") 'ido-exit-minibuffer)
  (define-key ido-completion-map (kbd "C-e") 'ido-exit-minibuffer))

(add-hook 'ido-setup-hook #'$ido-keys)

(icomplete-mode 1)
(setq icomplete-hide-common-prefix nil)
(setq icomplete-show-matches-on-no-input t)
(setq icomplete-in-buffer t)

(provide 'ido-config)
;;; ido-config.el ends here
