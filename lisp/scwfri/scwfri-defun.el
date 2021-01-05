;;;; scwfri-defun --- personal functions

;;; Commentary:
;;;     personal functions

;;; Code:

(defun $symbol-at-point ()
  "Return current symbol at point as a string."
  (let ((s (thing-at-point 'symbol)))
    (and (stringp s)
         (if (string-match "\\`[`']?\\(.*?\\)'?\\'" s)
             (match-string 1 s)
           s))))

(defun $eval-defun-view-results ()
  "Eval defun and view results in a new buffer."
  (interactive)
  (let ((result (pp-to-string (eval-defun nil))))
    (with-current-buffer
        (get-buffer-create "*ELISP RESULT*")
      (delete-region (point-min) (point-max))
      (insert result)
      (switch-to-buffer-other-window (current-buffer)))))

(defun $profile-session ()
  "Easily toggle emacs profiler."
  (interactive)
  (require 'profiler)
  (if (profiler-running-p)
      (progn (profiler-stop) (profiler-report))
    (profiler-start 'cpu)))

(defun $eval-defun-view-results ()
  "Eval defun and view results in a new buffer."
  (interactive)
  (let ((result (pp-to-string (eval-defun nil))))
    (with-current-buffer
        (get-buffer-create "*ELISP RESULT*")
      (delete-region (point-min) (point-max))
      (insert result)
      (switch-to-buffer-other-window (current-buffer)))))

(defun $add-server-postfix ()
  "Add the name of the connection type and server to the buffer name."
  (if (string-match "^/ssh:.*?:" (buffer-file-name (current-buffer)))
      (rename-buffer (concat (buffer-name (current-buffer)) "<" (match-string 0 (buffer-file-name (current-buffer))) ">")) nil))

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

(defun $show-full-file-path ()
  "Show full file path in msg."
  (interactive)
  (message "%s" (buffer-file-name)))

(defun $what-face (pos)
  "Return face under point POS."
  (interactive "d")
  (let ((face (or (get-char-property (pos) 'read-face-name)
                  (get-char-property (pos) 'face))))
    (if face (message "Face: %s" face) (message "No face at %d" pos))))

(defun $dir-grep ()
  "Run grep recursively from the directory of the current buffer or the default directory."
  (interactive)
  (let ((dir (file-name-directory (or load-file-name buffer-file-name default-directory))))
    (let ((command (read-from-minibuffer "Run grep (like this): "
                                         (cons (concat "grep --color --null -nH -ir -e  " dir) 32))))
      (grep command))))

(defun $file-grep ()
  "Run grep in the current file."
  (interactive)
  (let ((fname (buffer-file-name)))
    (let ((command (read-from-minibuffer "Run grep (like this): "
                                         (cons (concat "grep --color --null -nH -ir -e  " fname) 32))))
      (grep command))))

(defun $revert-buffer-noconfirm ()
  "Call `revert-buffer' with the NOCONFIRM argument set."
  (interactive)
  (revert-buffer nil t))

(defun $ido-open-recentf ()
  "Use `ido-completing-read' to \\[find-file] a recent file"
  (interactive)
  (if (find-file (ido-completing-read "Find recent file: " recentf-list))
    (message "Opening file...")
    (message "Aborting")))

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

(defun $goto-match-paren (arg)
  "Go to the matching parenthesis if on parenthesis, otherwise insert %.
vi style of % jumping to matching brace."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1))
        ((looking-back "\\s\)") (backward-list 1))
        (t (self-insert-command (or arg 1)))))

(define-key isearch-mode-map (kbd "<C-return>")
            (defun $isearch-done-opposite (&optional nopush edit)
              "End current search in the opposite side of the match."
              (interactive)
              (funcall #'isearch-done nopush edit)
              (when isearch-other-end (goto-char isearch-other-end))))

(defun $kill-back-to-indent ()
  "Kill from point back to the first non-whitespace character on the line."
  (interactive)
  (let ((prev-pos (point)))
    ($smarter-move-beginning-of-line nil)
    (kill-region (point) prev-pos)))

(defun $delete-trailing-whitespace ()
  "Delete trailing whitespace, and echo"
  (interactive)
  (delete-trailing-whitespace)
  (message "trailing whitespace deleted..."))

;; source: https://emacs.stackexchange.com/questions/51972/possible-to-use-emacs-undo-redo-without-keyboard-quit-ctrl-g/54142#54142
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

(provide 'scwfri-defun)
;;; defun.el ends here
