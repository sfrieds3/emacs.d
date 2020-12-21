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

(add-hook 'elpy-mode-hook (lambda () (highlight-indentation-mode -1)))

(provide 'elpy-config)
;;; elpy-config ends here
