;;; my-hooks.el -*- lexical-binding: t; -*-


(add-hook! 'text-mode-hook (lambda () (setq indent-line-function 'insert-tab)))
(add-hook! lisp-interaction-mode
  (apply-partially #'set-tab-width 2))
