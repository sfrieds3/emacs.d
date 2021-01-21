;;;; package --- summary

;;; Commentary:
;;;     theme configurations

;;; Code:

;;; set default preferred fonts
(defvar default-font)
(setq default-font
      (cond ((eq (system-name) 'mixolydian) "Iosevka Fixed SS14 10")
            ((eq (system-name) 'phrygian) "Iosevka Fixed SS14 14")
            (t nil)))

(when default-font
  (set-frame-font default-font nil t))

(add-to-list 'custom-theme-load-path (expand-file-name "themes" user-emacs-directory))
(add-to-list 'custom-theme-load-path (expand-file-name "themes"
                                                       (expand-file-name "themes" user-emacs-directory)))
(add-to-list 'load-path (expand-file-name "themes" user-emacs-directory))

;;; add everything in themes/ dir to load path
(let ((default-directory  (expand-file-name "themes" user-emacs-directory)))
  (normal-top-level-add-to-load-path '("."))
  (normal-top-level-add-subdirs-to-load-path))

;;; don't ask if themes are safe
(setq custom-safe-themes t)

;;(require 'modus-themes)
;;(require 'modus-vivendi-theme)
;;(load-theme 'modus-vivendi t)
;;(enable-theme 'modus-vivendi)

(provide 'theme-config)
;;; theme-config.el ends here
