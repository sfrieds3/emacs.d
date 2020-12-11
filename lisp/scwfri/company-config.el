;;;; package --- summary

;;; Commentary:
;;;     company-config

;;; Code:

(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
(define-key company-active-map (kbd "C-n") 'company-select-next-or-abort)
(define-key company-active-map (kbd "C-p") 'company-select-previous-or-abort)

(provide 'company-config)
;;; company-config.el ends here
