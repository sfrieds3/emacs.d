;;;; package --- summary

;;; Commentary:
;;;     icicles-config

;;; Code:

;;; notes:
;;; https://stackoverflow.com/questions/18931445/finding-files-using-icicles-in-emacs-under-windows-7
;;;    You need to read the Icicles doc a bit more: use S-TAB instead of TAB for apropos (regexp or substring) completion. That is apparently all you want here: match grob as a substring. (No need for any fuzzy matching for that.)
;;;
;;;    Since you want files matching grob anywhere under that directory, use icicle-locate-file. Give it that directory as the starting point. (And since you want to match grob anywhere in the file name, use S-TAB for completion.)
;;;
;;;    Icicles does provide "whizzy fuzzy matching like ido-mode" (in fact a lot whizzier). Ido's "flex" matching is the same as Icicles's "scatter" matching.
;;;
;;;    You can set the kind of completion you want to be one of the fuzzy-matching types. In the minibuffer, C-( cycles among the prefix-completion methods. M-( cycles among the apropos-completion methods. True fuzzy matching is a prefix completion method. Flex/scatter matching is a poor man's fuzzy matching, and it is an apropos completion method (so use M-( to cycle to it). To change the default matching, so you need not cycle to get the ones you prefer, customize option icicle-S-TAB-completion-methods-alist or icicle-TAB-completion-methods.



(require 'icicles)
(icy-mode 1)

(provide 'icicles-config)
;;; icicles-config.el ends here
