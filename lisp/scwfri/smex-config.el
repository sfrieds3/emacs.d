;;;; package --- summary

;;; Commentary:
;;;     smex-config

;;; Code:

(require 'smex)
(smex-initialize)

(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)


(provide 'smex-config)
;;; smex-config.el ends here
