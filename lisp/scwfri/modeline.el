;;;; package --- summary

;;; Commentary:
;;;     modeline

;;; Code:

;; mode line
(setq-default mode-line-format
              (list
               ;; file status info
               mode-line-mule-info
               mode-line-modified
               mode-line-frame-identification
               ;; current buffer name
               "%b "
               ;; current git branch
               '(vc-mode vc-mode)
               ;; mode-name
               " [%m] "
               ;; current line and column number
               "(%l:%c %P)"))

(provide 'modeline)
;;; modeline.el ends here
