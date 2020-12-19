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

(add-hook 'python-mode-hook (lambda()
                              (make-local-variable 'company-backends)
                              (setq company-backends (list (cons 'elpy-company-backend (copy-tree (car company-backends)))))))

(provide 'elpy-config)
;;; elpy-config ends here
