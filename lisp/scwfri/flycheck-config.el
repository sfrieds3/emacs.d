;;;; package --- summary

;;; Commentary:
;;;     evil-config

;;; Code:

(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)

(provide 'flycheck-config)
;;; flycheck.el ends here
