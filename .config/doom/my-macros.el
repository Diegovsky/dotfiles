;;; my-macros.el -*- lexical-binding: t; -*-
(defmacro inline-cmd (&rest args)
  `#'(lambda ()
       (interactive)
       ,@args))

(defmacro partial-cmd (func &rest args)
  `#'(lambda ()
       ,(format "Wrapper for (%s %s)." func args)
       (interactive)
       (,func ,@args)))
