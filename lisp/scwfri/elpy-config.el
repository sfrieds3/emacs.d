;;;; package --- summary

;;; Commentary:
;;;     elpy-config

;;; Code:

(if (version<= "24.4" emacs-version)
    (progn
      (load "elpy")
      (load "elpy-rpc")
      (load "elpy-shell")
      (load "elpy-profile")
      (load "elpy-refactor")
      (load "elpy-django")
      (elpy-enable)))

(provide 'elpy-config)
;;; elpy-config ends here
