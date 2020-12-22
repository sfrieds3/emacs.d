;;;; package --- summary

;;; Commentary:
;;;     modeline

;;; Code:

(defun simple-mode-line-render (left right)
  "Return a string of `window-width' length containing LEFT, and RIGHT
 aligned respectively."
  (let* ((available-width (- (window-width) (length left) 2)))
    (format (format " %%s %%%ds " available-width) left right)))

;(setq mode-line-format
;      '((:eval (simple-mode-line-render
;                ;; left
;                (format-mode-line "%b [%m] [%*]")
;                ;; right
;                (format-mode-line "Line: %l/%i Column: %c")))))

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
