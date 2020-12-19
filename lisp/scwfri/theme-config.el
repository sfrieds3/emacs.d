;;;; package --- summary

;;; Commentary:
;;;     theme configurations

;;; Code:

;;; set default preferred fonts
(defvar platform-default-font)
(setq platform-default-font
      (cond ((eq system-type 'windows-nt) "DejaVu Sans Mono 10")
            ((eq system-type 'gnu/linux) "Iosevka Fixed SS14 11")
            (t nil)))

(when platform-default-font
  (set-frame-font platform-default-font nil t))

(add-to-list 'custom-theme-load-path (expand-file-name "themes" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "themes" user-emacs-directory))

(global-set-key (kbd "C-c t") 'modus-themes-toggle)

(require 'modus-themes)
(require 'modus-operandi-theme)
(require 'modus-vivendi-theme)
(load-theme 'modus-vivendi t)
(enable-theme 'modus-vivendi)

(provide 'theme-config)
;;; theme-config.el ends here
