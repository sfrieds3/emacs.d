;;;; package --- summary

;;; Commentary:
;;;     modeline

;;; Code:

(defun simple-mode-line-render (left right)
  "Return a string of `window-width' length.  Containing LEFT, and RIGHT aligned respectively."
  (let ((available-width
         (- (window-total-width)
            (+ (length (format-mode-line left))
               (length (format-mode-line right))))))
    (append left
            (list (format (format "%%%ds" available-width) ""))
            right)))

(setq-default mode-line-format
              '((:eval (simple-mode-line-render
                        ;; Left.
                        (quote ("%e "
                                evil-mode-line-format
                                evil-mode-line-tag
                                mode-line-mule-info
                                mode-line-modified
                                " %b -"
                                vc-mode))
                        ;; Right.
                        (quote (
                                "[%m] (%l/%i:%c %p)"
                                mode-line-frame-identification
                                mode-line-modes
                                mode-line-misc-info))))))

(provide 'modeline)
;;; modeline.el ends here
