;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
(load! "evil-extra")
(load! "searches")
(load! "extra-ts")

(setq-default indent-tabs-mode nil)
(keymap-global-set "<esc>" #'doom/escape)

(setq user-full-name "John Doe"
      tab-width 2
      display-line-numbers-type 'relative
      evil-shift-width 2
      user-mail-address "john@doe.com"
      doom-font "FiraCode Nerd Font"
      default-frame-alist '((undecorated . t) (vertical-scroll-bars))
      doom-theme 'doom-one
      org-directory "~/org/"
      simpleclip-cut-keystrokes nil
      simpleclip-paste-keystrokes nil
      treesit-extra-load-path (list "/usr/lib/helix/runtime/grammars/")
      vterm-buffer-name-string "vterm: %s"
      treesit-load-name-override-list (mapcar
                                       #'(lambda (file)
                                           (let* ((file-base (file-name-sans-extension file))
                                                  (lang (intern file-base))
                                                  (funcname (format "tree_sitter_%s" file-base)))
                                             (list lang file-base funcname)))
                                       (cl-remove-if
                                        (lambda (file) (string-prefix-p "." file))
                                        (directory-files (car treesit-extra-load-path)))))
(simpleclip-mode 1)
(display-line-numbers-mode 1)

(add-hook! 'text-mode-hook (lambda () (setq indent-line-function 'insert-tab)))
(defmacro inline-cmd (&rest args)
  `#'(lambda ()
       (interactive)
       ,@args))

(defmacro partial-cmd (func &rest args)
  `#'(lambda ()
       ,(format "Wrapper for (%s %s)." func args)
       (interactive)
       (,func ,@args)))

(after! corfu
  (map!
   ;; undefine C-SPC on normal mode
   :map corfu-mode-map
   :n "C-SPC" nil)
  (map!
   :n "C-SPC" #'consult-buffer))

(map!
 :map corfu-map
 :i "S-TAB" #'corfu-previous
 :i "<backtab>" #'corfu-previous)


(after! evil-motion
  (map!
   :map evil-motion-state-map
   :vn "(" nil
   :vn ")" nil))

(map!
 :map emacs-lisp-mode-map
 :i "<tab>" #'evil-shift-right-line)



(map!
 :map evil-visual-state-map
 "R" nil)


(map!
 :n "C-<tab>" #'+tabs:next-or-goto
 :i "<backtab>" #'evil-shift-left-line
 :n "<" #'evil-shift-left-line
 :n ">" #'evil-shift-right-line
 :n "M-h" #'evil-window-left
 :n "M-j" #'evil-window-down
 :n "M-k" #'evil-window-up
 :n "M-l" #'evil-window-right
 :n "M-o" #'evil-window-split
 :n "M-i" #'evil-window-vsplit
 :n "M-t" #'+vterm/here
 :n "C-l" #'evil-mc-undo-all-cursors
 :n "j" #'evil-next-visual-line
 :n "k" #'evil-previous-visual-line
 :v "r" #'evil-paste-after
 :v "R" #'evil-paste-before
 :vn "(" #'evil-inner-paren
 :vn ")" #'evil-inner-paren
 :vn "s" (inline-cmd
           (if (use-region-p)
               (evil-change (region-beginning) (region-end))
               (evil-change (point) (+ 1 (point)))))
 :i "C-S-v" #'simpleclip-paste
 :leader
 :nv "P" #'simpleclip-paste
 :nv "y" #'simpleclip-copy
 :nv "r" #'simpleclip-paste
 :nv "R" #'simpleclip-paste
 :n "SPC" (inline-cmd
           (call-interactively
            (if (projectile-project-p)
                #'projectile-find-file
                #'find-file))))


(after! vterm
  (map!
   :map vterm-mode-map
   :n "p" (partial-cmd vterm-yank)
   :n "SPC-P" (partial-cmd vterm-insert (simpleclip-get-contents))
   :n "SPC-R" (partial-cmd vterm-insert (simpleclip-get-contents))
   :n "SPC-r" (partial-cmd vterm-insert (simpleclip-get-contents))
   :ni "C-S-v" (partial-cmd vterm-insert (simpleclip-get-contents))
   :ni "C-c" (partial-cmd vterm-send "C-c")))

(defun spawn-vterm ()
  (let ((frame (selected-frame)))
    (with-current-buffer (call-interactively #'+vterm/here)
      (add-hook 'kill-buffer-hook
                (apply-partially #'delete-frame frame)
                nil t))))
