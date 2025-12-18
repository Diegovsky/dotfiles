(defun evil-surround-char (char)
  (interactive (evil-surround-input-char))
  (evil-surround-region (point) (+ 1 (point)) 'inclusive char))

(defun evil-h-surround-region (beg end type char)
  (interactive (evil-surround-input-region-char))
  (evil-surround-region beg end type char)
  (let ((beg (- beg 0))
        (end (+ end 1)))
   (evil-visual-make-selection beg end)))

(defun evil-make-selection (beg end)
  (interactive (evil-operator-range))
  (evil-visual-char beg end))
