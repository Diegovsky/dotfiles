;;; searches.el -*- lexical-binding: t; -*-
(defun buffer-search-re (regexp)
  "Get a list of all regexp matches positions in the current buffer"
  (declare (ftype (function () (list))))

  (save-match-data
    (let ((regexp (or regexp))
          (string (buffer-string))
          (pos 0)
          matches)
     (while (string-match regexp string pos)
         ;; (push (match-string 0 string) matches)
         (setq pos (match-end 0))
         (push pos matches))
     (reverse matches))))

(defun evil-mc-all-regex (&optional regexp)
  (interactive)
  (let* ((regexp (or regexp (car evil-search-forward-history)))
         (matches (buffer-search-re regexp)))
    (if (> (length matches) 0)
      (progn
        (goto-char (car matches))
        (setq matches (cdr matches))
        (evil-mc-run-cursors-before)
        (cl-loop for pos in matches do
          (evil-mc-make-cursor-at-pos pos))
        (evil-mc-resume-cursors)))))
