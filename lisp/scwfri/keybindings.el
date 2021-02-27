;;;; keybindings.el --- general keybindings

;;; Commentary:
;;;     keybindings

;;; Code:

;;; move between windows with shift-arrow keys
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

;;; easy extended commands
(global-set-key (kbd "C-x C-,") 'execute-extended-command)

;;; custom functions
(global-set-key (kbd "C-c s d") '$dir-grep)
(global-set-key (kbd "C-c s s") '$file-grep)
(global-set-key (kbd "C-c s f") 'find-dired)
(global-set-key (kbd "C-a") '$smarter-move-beginning-of-line)
(global-set-key (kbd "C-x 8 s") '$insert-zero-width-space)

;;; SPC commands
(global-set-key (kbd "C-c SPC l") '$select-line)
(global-set-key (kbd "C-c SPC r") 'replace-regexp)
(global-set-key (kbd "C-c SPC i") 'indent-region)
(global-set-key (kbd "C-c SPC W") '$delete-trailing-whitespace)
(global-set-key (kbd "C-c SPC l") 'goto-line)
(global-set-key (kbd "C-c SPC b e") 'eval-buffer)
(global-set-key (kbd "C-c SPC b r") '$revert-buffer-noconfirm)

;;; general customizations
(global-set-key (kbd "C-c [") 'previous-error)
(global-set-key (kbd "C-c ]") 'next-error)
(global-set-key (kbd "C-c o") 'occur)
(global-set-key (kbd "C-c O") 'multi-occur-in-matching-buffers)
(global-set-key (kbd "C-c e") 'eval-defun)
(global-set-key (kbd "C-c r") 'recentf-open-files)
(global-set-key (kbd "C-x C-b") 'buffer-menu-other-window)
(global-set-key (kbd "C-h L") 'describe-keymap)

;;; window management
(global-set-key (kbd "C-S-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "C-S-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "C-S-<down>") 'shrink-window)
(global-set-key (kbd "C-S-<up>") 'enlarge-window)
(global-set-key (kbd "C-c D") 'delete-window)
(global-set-key (kbd "M-o") 'other-window)

;;; hippie expand -- also C-M-i for completion mode
(global-set-key (kbd "C-.") 'hippie-expand)

;;; string insert region
(global-set-key (kbd "C-c I") 'string-insert-rectangle)

;;; indent
(global-set-key (kbd "C-x TAB") 'indent-code-rigidly)
(global-set-key (kbd "C-M-<backspace>") '$kill-back-to-indent)

;;; want to go to correct indentation on enter
(global-set-key (kbd "RET") 'newline-and-indent)

;;; no C-z
(global-set-key (kbd "C-z") nil)

;;; modify kill-word
(global-set-key (kbd "C-w") 'backward-kill-word)
(global-set-key (kbd "C-x C-k") 'kill-region)
(global-set-key (kbd "C-c C-k") 'kill-region)

;;; version control
(global-set-key (kbd "C-c g \\") 'vc-diff)
(global-set-key (kbd "C-c g h") 'vc-region-history)
(global-set-key (kbd "C-c g s") 'vc-dir)

;;; aliases
(defalias 'qrr 'query-replace-regexp)
(defalias 'PrettyXML '$pretty-xml)

;;; random isearch define
(define-key isearch-mode-map (kbd "<C-return>")
            (defun $isearch-done-opposite (&optional nopush edit)
              "End current search in the opposite side of the match."
              (interactive)
              (funcall #'isearch-done nopush edit)
              (when isearch-other-end (goto-char isearch-other-end))))


(provide 'keybindings)
;;; keybindings.el ends here
