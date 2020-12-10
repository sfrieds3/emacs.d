(require 'general)
(general-evil-define-key 'normal 'global
                         :prefix "\\"
                         "SPC" 'other-window
                         "w" 'delete-trailing-whitespace
                         "RET" 'lazy-highlight-cleanup
                         "h" 'projectile-find-file
                         "f" 'find-name-dired
                         "b" 'buffer-menu)

(provide 'general-config)
