;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
(load! "my-macros")
(load! "evil-extra")
(load! "searches")
(load! "extra-ts")
(load! "my-lsp-bridge")
(load! "my-funcs")
(load! "my-vertico")
(load! "my-hooks")
(load! "my-vterm")
(load! "my-projectile")

(setq-default indent-tabs-mode nil)
(keymap-global-set "<esc>" #'doom/escape)

(setq user-full-name "John Doe"
      evil-shift-width 2
      tab-width 2
      display-line-numbers-type 'relative
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


(map!
 :n "C-SPC" #'consult-buffer
 :map corfu-mode-map
 :n "C-SPC" nil
 :i "S-TAB" #'corfu-previous
 :i "<backtab>" #'corfu-previous
 :map evil-motion-state-map
 :vn "(" nil
 :vn ")" nil
 :map evil-visual-state-map
 "R" nil
 :map vterm-mode-map
 :n "M-x" #'execute-extended-command
 :n "p" (partial-cmd vterm-yank)
 :n "SPC-P" (partial-cmd vterm-insert (simpleclip-get-contents))
 :n "SPC-R" (partial-cmd vterm-insert (simpleclip-get-contents))
 :n "SPC-r" (partial-cmd vterm-insert (simpleclip-get-contents))
 :ni "C-S-v" (partial-cmd vterm-insert (simpleclip-get-contents))
 :ni "C-c" (partial-cmd vterm-send "C-c"))

(map!
 :n "M-h" #'evil-window-left
 :n "M-j" #'evil-window-down
 :n "M-k" #'evil-window-up
 :n "M-l" #'evil-window-right

 :n "M-H" #'+evil/window-move-left
 :n "M-J" #'+evil/window-move-down
 :n "M-K" #'+evil/window-move-up
 :n "M-L" #'+evil/window-move-right

 :v "S" #'replace-string

 :n "M-o" #'evil-window-split
 :n "M-i" #'evil-window-vsplit

 :n "M-t" #'spawn-vterm

 :n "C-<tab>" #'+tabs:next-or-goto

 :n "C-l" (inline-cmd
           (call-interactively #'evil-force-normal-state)
           (evil-mc-undo-all-cursors))
 :n ">" (kbd "v>")
 :n "<" (kbd "v<")

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
 :v "r" #'simpleclip-paste
 :v "R" #'simpleclip-paste
 :n "SPC" (inline-cmd
           (call-interactively
            (if (projectile-project-p)
                #'projectile-find-file
                #'find-file))))

