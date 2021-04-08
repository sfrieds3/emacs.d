;;;; scwfri-defun --- personal functions

;;; Commentary:
;;;     personal functions

;;; Code:

;;;###autoload
(defun $insert-zero-width-space ()
  "Insert zero width space."
  (interactive)
  (insert-char ?\u200B))

;;;###autoload
(defun $symbol-at-point ()
  "Return current symbol at point as a string."
  (let ((s (thing-at-point 'symbol)))
    (and (stringp s)
         (if (string-match "\\`[`']?\\(.*?\\)'?\\'" s)
             (match-string 1 s)
           s))))

;;;###autoload
(defun $profile-session ()
  "Easily toggle Emacs profiler."
  (interactive)
  (require 'profiler)
  (if (profiler-running-p)
      (progn (profiler-stop) (profiler-report))
    (profiler-start 'cpu)))

;;;###autoload
(defun $eval-defun-view-results ()
  "Eval defun and view results in a new buffer."
  (interactive)
  (let ((result (pp-to-string (eval-defun nil))))
    (with-current-buffer
        (get-buffer-create "*ELISP RESULT*")
      (delete-region (point-min) (point-max))
      (insert result)
      (switch-to-buffer-other-window (current-buffer)))))

;;;###autoload
(defun $add-server-postfix ()
  "Add the name of the connection type and server to the buffer name."
  (if (string-match "^/ssh:.*?:" (buffer-file-name (current-buffer)))
      (rename-buffer (concat (buffer-name (current-buffer)) "<" (match-string 0 (buffer-file-name (current-buffer))) ">")) nil))

;;;###autoload
(defun $toggle-show-trailing-whitespace ()
  "Toggle 'show-trailing-whitespace'."
  (interactive)
  (if (eq 1 show-trailing-whitespace)
      (progn
        (setq show-trailing-whitespace nil)
        (message "show-trailing-whitespace nil"))
      (progn
        (setq show-trailing-whitespace 1)
        (message "show-trailing-whitespace t"))))

;;;###autoload
(defun $show-full-file-path ()
  "Show full file path in msg."
  (interactive)
  (message "%s" (buffer-file-name)))

;;;###autoload
(defun $what-face (pos)
  "Return face under point POS."
  (interactive "d")
  (let ((face (or (get-char-property (pos) 'read-face-name)
                  (get-char-property (pos) 'face))))
    (if face (message "Face: %s" face) (message "No face at %d" pos))))

;;;###autoload
(defun $dir-grep ()
  "Run grep recursively from the directory of the current buffer or the default directory."
  (interactive)
  (let ((dir (file-name-directory (or load-file-name buffer-file-name default-directory))))
    (let ((command (read-from-minibuffer "Run grep (like this): "
                                         (cons (concat "grep --color --null -nH -ir -e  " dir) 32))))
      (grep command))))

;;;###autoload
(defun $file-grep ()
  "Run grep in the current file."
  (interactive)
  (let ((fname (buffer-file-name)))
    (let ((command (read-from-minibuffer "Run grep (like this): "
                                         (cons (concat "grep --color --null -nH -ir -e  " fname) 32))))
      (grep command))))

;;;###autoload
(defun $revert-buffer-noconfirm ()
  "Call `revert-buffer' with the NOCONFIRM argument set."
  (interactive)
  (revert-buffer nil t))

;;;###autoload
(defun $smarter-move-beginning-of-line (arg)
  "Move point back to indentation of beginning of line.
  
Move point to the first non-whitespace character on this line.
If point is already there, move to the beginning of the line.
Effectively toggle between the first non-whitespace character and
the beginning of the line.

If ARG is not nil or 1, move forward ARG - 1 lines first.  If
point reaches the beginning or end of the buffer, stop there."
  (interactive "^p")
  (setq arg (or arg 1))

  ;; Move lines first
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))

  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))

;;;###autoload
(defun $goto-match-paren (arg)
  "Go to the matching parenthesis if ARG on parenthesis, otherwise insert %.
vi style of % jumping to matching brace."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1))
        (t
         (backward-char 1)
         (cond ((looking-at "\\s\)")
                (forward-char 1) (backward-list 1))
               (t
                (while (not (looking-at "\\s("))
                  (backward-char 1)
                  (cond ((looking-at "\\s\)")
                         (message "->> )")
                         (forward-char 1)
                         (backward-list 1)
                         (backward-char 1)))))))))

;;;###autoload
(defun $kill-back-to-indent ()
  "Kill from point back to the first non-whitespace character on the line."
  (interactive)
  (let ((prev-pos (point)))
    ($smarter-move-beginning-of-line nil)
    (kill-region (point) prev-pos)))

;;;###autoload
(defun $delete-trailing-whitespace ()
  "Delete trailing whitespace, and echo."
  (interactive)
  (delete-trailing-whitespace)
  (message "trailing whitespace deleted..."))

;; source: https://emacs.stackexchange.com/questions/51972/possible-to-use-emacs-undo-redo-without-keyboard-quit-ctrl-g/54142#54142
;;;###autoload
(defun $simple-redo ()
  "Simple redo function."
  (interactive)
  (let
    ((last-command
       (cond
         ;; Break undo chain, avoid having to press Ctrl-G.
         ((string= last-command 'simple-undo) 'ignore)
         ;; Emacs undo uses this to detect successive undo calls.
         ((string= last-command 'simple-redo) 'undo)
         (t last-command))))
    (condition-case err
                    (progn
                      (undo) t)
                    (error
                      (message "%s" (error-message-string err)))))
  (setq this-command 'simple-redo))

;;;###autoload
(defun $simple-undo ()
  "Simple undo function."
  (interactive)
  (let
    ((last-command
       (cond
         ;; Emacs undo uses this to detect successive undo calls.
         ((string= last-command 'simple-undo) 'undo)
         ((string= last-command 'simple-redo) 'undo)
         (t last-command))))
    (condition-case err
                    (progn
                      (undo-only) t)
                    (error
                      (message "%s" (error-message-string err)))))
  (setq this-command 'simple-undo))

(defun $load-theme--disable-current-theme (theme &rest args)
  "Disable the current THEME before loading a new one."
  (mapcar #'disable-theme custom-enabled-themes))

;;;###autoload
(defun narrow-or-widen-dwim (p)
  "If the buffer is narrowed, it widens.  Otherwise, it narrows intelligently.
Intelligently means: region, subtree, or defun, whichever applies
first.

With prefix P, don't widen, just narrow even if buffer is already
narrowed."
  (interactive "P")
  (declare (interactive-only))
  (cond ((and (buffer-narrowed-p) (not p)) (widen))
        ((region-active-p)
         (narrow-to-region (region-beginning) (region-end)))
        ((derived-mode-p 'org-mode) (org-narrow-to-subtree))
        (t (narrow-to-defun))))

(global-set-key (kbd "C-x n x") 'narrow-or-widen-dwim)

;;;###autoload
(defun $unfill-paragraph ()
  "Convert a multi-line paragraph into a single line of text."
  (interactive)
  (let ((fill-column (point-max)))
    (fill-paragraph nil)))

;;;###autoload
(defun $kill-and-delete-window ()
  "Kill and delete current window."
  (interactive)
  (kill-this-buffer)
  (delete-window))

;;;###autoload
(defun $dont-kill-scratch ()
  "Never kill scratch buffer."
  (if (not (equal (buffer-name) "*scratch*"))
      t
    (message "Not allowed to kill %s, burying instead" (buffer-name))
    (bury-buffer)
    nil))

;;;###autoload
(defun $dont-kill-messages ()
  "Never kill messages bufffer."
  (if (not (equal (buffer-name) "*Messages*"))
      t
    (message "Not allowed to kill %s, burying instead" (buffer-name))
    (bury-buffer)
    nil))

;;;###autoload
(defun $scroll-down-in-place (n)
  "Scroll down N lines, keeping cursor postion."
  (interactive "p")
  (forward-line (- n))
  (scroll-down n))

;;;###autoload
(defun $scroll-up-in-place (n)
  "Scroll up N lines, keeping cursor position."
  (interactive "p")
  (forward-line n)
  (scroll-up n))

;;;###autoload
(defun $scroll-down (n)
  "Scroll down N lines."
  (interactive "p")
  (scroll-down n))

;;;###autoload
(defun $scroll-up (n)
  "Scroll up N lines."
  (interactive "p")
  (scroll-up n))

;;;###autoload
(defun $scroll-up-multiline ()
  "Scroll up multiple lines."
  (interactive)
  (scroll-up (/ (window-body-height) 3)))

;;;###autoload
(defun $scroll-down-multiline ()
  "Scroll up multiple lines."
  (interactive)
  (scroll-down (/ (window-body-height) 3)))

;;;###autoload
(defun $toggle-var (var)
  "Toggle variable VAR."
  (interactive
   (let* ((def  (variable-at-point))
             (def  (and def
                        (not (numberp def))
                        (memq (symbol-value def) '(nil t))
                        (symbol-name def))))
            (list
             (completing-read
              "Toggle value of variable: "
              obarray (lambda (c)
                        (unless (symbolp c) (setq c  (intern c)))
                        (and (boundp c)  (memq (symbol-value c) '(nil t))))
              'must-confirm nil 'variable-name-history def))))
  (let ((sym  (intern var)))
    (set sym (not (symbol-value sym)))
    (message "`%s' is now `%s'" var (symbol-value sym))))

;;;###autoload
(defun swap-windows ()
 "If you have 2 windows, it swaps them.
from: https://sites.google.com/site/steveyegge2/my-dot-emacs-file" 
  (interactive) 
  (cond ((not (= (count-windows) 2)) 
    (message "You need exactly 2 windows to do this."))
 (t
 (let* ((w1 (first (window-list)))
	 (w2 (second (window-list)))
	 (b1 (window-buffer w1))
	 (b2 (window-buffer w2))
	 (s1 (window-start w1))
	 (s2 (window-start w2)))
 (set-window-buffer w1 b2)
 (set-window-buffer w2 b1)
 (set-window-start w1 s2)
 (set-window-start w2 s1)))))

;;;###autoload
(defun rename-file-and-buffer (new-name)
 "Renames both current buffer and file it's visiting to NEW-NAME." (interactive "sNew name: ")
 (let ((name (buffer-name))
	(filename (buffer-file-name)))
 (if (not filename)
	(message "Buffer '%s' is not visiting a file!" name)
 (if (get-buffer new-name)
	 (message "A buffer named '%s' already exists!" new-name)
	(progn 	 (rename-file filename new-name 1) 	 (rename-buffer new-name) 	 (set-visited-file-name new-name) 	 (set-buffer-modified-p nil))))))

;;;##zautoload
(defun move-buffer-file (dir)
 "Moves both current buffer and file it's visiting to DIR." (interactive "DNew directory: ")
 (let* ((name (buffer-name))
	 (filename (buffer-file-name))
	 (dir
	 (if (string-match dir "\\(?:/\\|\\\\)$")
	 (substring dir 0 -1) dir))
	 (newname (concat dir "/" name)))

 (if (not filename)
	(message "Buffer '%s' is not visiting a file!" name)
 (progn 	(copy-file filename newname 1) 	(delete-file filename) 	(set-visited-file-name newname) 	(set-buffer-modified-p nil) 	t)))) 


(provide 'scwfri-defun)
;;; defun.el ends here
