;;;; package --- summary

;;; Commentary:
;;;     uniquify-config

;;; Code:

(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)
(setq uniquify-separator "/")
(setq uniquify-after-kill-buffer-p t) ;; rename after killing uniquified
(setq uniquify-ignore-buffers-re "^\\*") ;; dont change names of special buffers.

(provide 'uniquify-config)
;;; uniquify-config.el ends here
