;;; my-vterm.el -*- lexical-binding: t; -*-

(defun vterm-with (command)
  (with-current-buffer (call-interactively #'+vterm/here)
    (vterm-insert (concat command "\r"))))


(defvar my-frame-vterm nil
  "internal alist to keep track of a frame's vterm")

(defun my/delete-frame-hook (frame)
  (let ((buffers (alist-get frame my-frame-vterm)))
    (when buffers
      (dolist (vterm buffers)
          (kill-vterm vterm))
      ; clear buffers
      (setf buffers nil))))

(add-hook 'delete-frame-functions #'my/delete-frame-hook)

(defun kill-vterm (&optional buffer)
  (interactive (current-buffer))

  (with-current-buffer buffer
    (set-process-query-on-exit-flag vterm--process nil)
    (vterm-insert "exit\n")
    (kill-buffer vterm)))


(defun spawn-vterm (&optional keep-frame)
  (interactive '(t))
  (let ((frame (selected-frame)))
    (with-current-buffer (call-interactively #'+vterm/here)
      (let ((frame-buf-list (alist-get frame my-frame-vterm)))
         (push (current-buffer) frame-buf-list))

      ;; Delete frame when buffer dies
      (when (not keep-frame)
        (add-hook 'kill-buffer-hook
                  (apply-partially #'delete-frame frame)
                  nil t)))))
