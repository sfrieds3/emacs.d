;;;; evil-defun.el --- defun used with evil mode

;;; Commentary:
;;;     defun used with evil mode

;;; Code:

  ;;;###autoload
(defun $evil-clear-highlights ()
  "Clear highlight from evil-search."
  (interactive)
  (evil-ex "nohl")
  (exit-minibuffer))

  ;;;###autoload
(defun $evil-star-keep-position ()
  "Keep position when searching."
  (interactive)
  (evil-search-word-forward)
  (evil-search-previous))

  ;;;###autoload
(defun $evil-visualstar-keep-position ()
  "Keep current position on visual star search."
  (interactive)
  (when (region-active-p)
    (evil-search-word-forward)
    (evi-search-word-backward)
    (cua-cancel)))

  ;;;###autoload
(defun $evil-set-jump-args (&rest ns)
  "Preserve jump list with dumb-jump.  NS args."
  (evil-set-jump))
(advice-add 'dumb-jump-goto-file-line :before #'$evil-set-jump-args)

  ;;;###autoload
(defun $evil-split-right-and-move ()
  "Split window to the right and move to it."
  (interactive)
  (split-window-right)
  (evil-window-right 1))

  ;;;###autoload
(defun $evil-scroll-down-keep-pos ()
  (interactive)
  (evil-scroll-line-down 1)
  (evil-next-visual-line))

  ;;;###autoload
(defun $evil-scroll-up-keep-pos ()
  (interactive)
  (evil-scroll-line-up 1)
  (evil-previous-visual-line))

(provide 'evil-defun)
;;; evil-defun ends here
