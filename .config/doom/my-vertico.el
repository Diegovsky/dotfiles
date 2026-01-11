;;; my-vertico.el -*- lexical-binding: t; -*-

(defun my/vertico-insert ()
 "Inserts current input. If it was already inserted, accepts it."
 (interactive)
 (let ((current (vertico--candidate))
       (input (minibuffer-contents)))
   (vertico-insert)
   (vertico--exhibit)
   (when (or
          (not (string-suffix-p "/" current))
          (<= vertico--total 1)
          (string= current input))
     (vertico-exit))))

(map!
 :map vertico-map
 :g "<RET>" #'my/vertico-insert
 :g "<tab>" #'vertico-next
 :g "<backtab>" #'vertico-previous)
