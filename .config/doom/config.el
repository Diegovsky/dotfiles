;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "John Doe"
      user-mail-address "john@doe.com"
      doom-font "FiraCode Nerd Font"
      tab-width 2
      evil-shift-width 2
      default-frame-alist '((undecorated . t) (vertical-scroll-bars))
      doom-theme 'doom-one
      display-line-numbers-type t
      org-directory "~/org/"
      simpleclip-cut-keystrokes nil
      simpleclip-paste-keystrokes nil)

(simpleclip-mode 1)

(defmacro partial-command (func &rest args)
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
   :n "C-SPC" #'switch-to-buffer))


(after! evil-motion
  ;; override "s" to work like neovim:
  ;; normal: change current char
  ;; visual: change region
  (map!
   :n "(" #'evil-inner-paren
   :n ")" nil
   :n "s" #'(lambda (
                     (interactive)
                     (if (use-region-p
                           (evil-change (region-beginning) (region-end)
                                           (evil-change (point) (+ 1 (point))))))))))

(map!
 :map emacs-lisp-mode-map
 :i "<tab>" #'evil-shift-right-line)

(map!
 :map evil-visual-state-map
 "R" nil)


(map!
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
 :v "r" #'evil-paste-after
 :v "R" #'evil-paste-before
 :leader
 :nv "P" #'simpleclip-paste
 :nv "y" #'simpleclip-copy
 :nv "r" #'simpleclip-paste
 :nv "R" #'simpleclip-paste
 :n "SPC" #'find-file)



(defun evil-surround-char (char)
  (interactive (evil-surround-input-char))
  (evil-surround-region (point) (+ 1 (point)) 'exclusive char))

(map!
 :map evil-surround-mode-map
 :n "ma" #'evil-surround-char
 :nv "md" #'evil-surround-delete
 :v "ma" #'evil-surround-region)


(after! vterm
  (map!
   :map vterm-mode-map
   :ni "C-c" (partial-command vterm-send "C-c")))

(defun finish-vterm ()
  (interactive)
  (kill-buffer)
  (delete-frame))

(defun spawn-vterm ()
  (call-interactively #'+vterm/here))
