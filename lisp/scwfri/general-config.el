(require 'general)
(general-evil-define-key 'normal 'global
                         :prefix "\\"
                         "SPC" 'other-window
                         "W" 'delete-trailing-whitespace
                         "RET" 'lazy-highlight-cleanup
                         "h" 'projectile-find-file)

(provide 'general-config)
