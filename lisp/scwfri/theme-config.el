;;;; theme-config --- configure theme-related items

;;; Commentary:
;;;     theme configurations

;;; Code:

;;; set default preferred fonts
(defvar $default-font-size
  (cond ((string= (system-name) "mixolydian") "10")
        ((string= (system-name) "phrygian") "14")
        (t "13")))

(defvar $preferred-font
  '("Iosevka Fixed SS14"
    "DejaVu Sans Mono"))

(defvar $current-font nil)

;;;###autoload
(defun $set-current-font (font &optional size)
  "Set current font to FONT and (optional) SIZE."
  (let ((font-size (or size $default-font-size)))
       (set-frame-font (string-join `(,font ,font-size) " ") nil t)
       (setf $current-font font)))

;;;###autoload
(defun $set-preferred-font (&optional frame)
  "Set preferred font and size for FRAME."
  (interactive)
  (catch 'done
    (with-selected-frame (or frame (selected-frame))
      (dolist (font $preferred-font)
        (when (ignore-errors (x-list-fonts font))
          ($set-current-font font)
          (throw 'done nil))))))

;;;###autoload
 (defun $cycle-preferred-font ()
   "Cycle through preferred fonts."
   (interactive)
   (catch 'done
     (dolist (font $preferred-font)
       (unless (string= font $current-font)
         (when (ignore-errors (x-list-fonts font))
           ($set-current-font font)
           (throw 'done nil))))))

;;;###autoload
(defun $set-path ()
  "Set path for themes and packages."
  (add-to-list 'custom-theme-load-path (expand-file-name "themes" user-emacs-directory))
  (add-to-list 'custom-theme-load-path (expand-file-name "themes"
                                                         (expand-file-name "themes" user-emacs-directory)))
  (add-to-list 'load-path (expand-file-name "themes" user-emacs-directory))

;;; add everything in themes/ dir to load path
  (let ((default-directory  (expand-file-name "themes" user-emacs-directory)))
    (normal-top-level-add-to-load-path '("."))
    (normal-top-level-add-subdirs-to-load-path)))

(provide 'theme-config)
;;; theme-config.el ends here
