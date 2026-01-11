;;; my-funcs.el -*- lexical-binding: t; -*-

(defun set-tab-width (number)
 (interactive "nNew tab width: ")
 (setq
  tab-width number
  evil-shift-width number))


(defun show-major-mode ()
  (interactive)
  (message "%s" major-mode))


(defun show-minor-modes ()
  (interactive)
  (let ((buf (get-buffer-create "*minor-modes*"))
        (the-list minor-mode-list))
    (with-current-buffer buf
      (erase-buffer)
      (insert (mapconcat
               (lambda (x) (format "%s" x))
               the-list
               "\n"))
      (switch-to-buffer buf))))
