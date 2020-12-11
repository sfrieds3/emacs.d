(custom-set-faces
 '(slime-repl-inputed-output-face ((t (:foreground "yellow")))))

(custom-set-variables
 '(company-backends
   '(company-lsp company-bbdb company-eclim company-semantic company-clang company-xcode company-cmake company-capf company-files
                 (company-dabbrev-code company-gtags company-etags company-keywords)
                 company-oddmuse company-dabbrev))
 '(custom-safe-themes
   '("36ca8f60565af20ef4f30783aa16a26d96c02df7b4e54e9900a5138fb33808da" "b89ae2d35d2e18e4286c8be8aaecb41022c1a306070f64a66fd114310ade88aa" default)))

(provide 'shared-config)
