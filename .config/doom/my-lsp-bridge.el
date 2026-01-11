;;; my-lsp-bridge.el -*- lexical-binding: t; -*-
(use-package! lsp-bridge
  :config
  (global-lsp-bridge-mode))

(setq
 lsp-bridge-enable-hover-diagnostic t )

(defun my/lsp-bridge-doc-handler ()
  (interactive)
  (lsp-bridge-popup-documentation)
  :deferred)


(set-lookup-handlers! 'lsp-bridge-mode
  :documentation #'my/lsp-bridge-doc-handler)

(add-hook! 'before-save-hook
  (when lsp-bridge-mode
    (message "Absolute cinema")
    (call-interactively #'lsp-bridge-code-format)))



(defun my/close-current-window ()
  (interactive)
  (kill-current-buffer)
  (delete-window))


(map!
 :map lsp-bridge-ref-mode-map
 :n "q" #'my/close-current-window
 :n "<esc>" #'my/close-current-window)


(map!
 :map lsp-bridge-mode-map
 :i "C-SPC" #'lsp-bridge-popup-complete-menu
 :i "<tab>" #'acm-select-next
 :i "<backtab>" #'acm-select-prev
 :n "gr" #'lsp-bridge-find-references
 :n "gd" #'lsp-bridge-find-def
 :n "gi" #'lsp-bridge-find-impl
 :n "gT" #'lsp-bridge-find-type-def
 :n "[d" #'lsp-bridge-diagnostic-jump-next
 :n "]d" #'lsp-bridge-diagnostic-jump-prev
 :leader
 :n "D" #'lsp-bridge-diagnostic-list
 :n "cr" #'lsp-bridge-rename
 :n "ca" #'lsp-bridge-code-action
 :n "f" #'lsp-bridge-code-format)
