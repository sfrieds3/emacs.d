;;;; package --- summary

;;; Commentary:
;;;     evil-config

;;; Code:
(require 'dumb-jump)
(add-hook 'xref-backend-functions #'dumb-jump-xref-activate)

(provide 'dumb-jump-config)
;;; dumb-jump-config.el ends here
