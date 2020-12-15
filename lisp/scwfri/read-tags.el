;;;; package --- summary

;;; Commentary:
;;;     read-tags

;;; Code:

(defun read-lines (filePath)
  "Return a list of lines of a file at filePath."
  (with-temp-buffer
    (insert-file-contents filePath)
    (split-string (buffer-string) "\n" t)))

(provide 'read-tags)
;;; read-tags.el ends here
