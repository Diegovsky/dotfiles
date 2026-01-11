;;; extra-ts.el -*- lexical-binding: t; -*-

(push '("\\.kdl\\'" . kdl-ts-mode) auto-mode-alist)

;;;###autoload
(define-derived-mode kdl-ts-mode text-mode "KDL[ts]"
  "Major mode for editing KDL with tree-sitter."
  (setq-local font-lock-defaults nil)
  (when (treesit-ready-p 'kdl)
    (treesit-parser-create 'kdl)
    (kdl-ts-setup)))

(defvar kdl-ts-font-lock-rules
  '(:language kdl
    :override t
    :feature delimiter
    (["{" "}"] @font-lock-bracket-face)

    :language kdl
    :override t
    :feature node
    ((prop (identifier) @font-lock-variable-name-face))

    :language kdl
    :override t
    :feature node
    ((node (identifier) @font-lock-function-name-face))


    :language kdl
    :override t
    :feature node
    ((string) @font-lock-string-face)

    :language kdl
    :override t
    :feature node
    ((number) @font-lock-number-face)

    :language kdl
    :override t
    :feature node
    ((boolean) @font-lock-constant-face)

    :language kdl
    :override t
    :feature node
    ((keyword) @font-lock-keyword-face)

    :language kdl
    :override t
    :feature comment
    ([(single_line_comment) (multi_line_comment) (node (node_comment))] @font-lock-comment-face)))

(defvar kdl-ts-indent-rules
  `((kdl
     ((parent-is "document") column-0 0)
     ((node-is "}") grand-parent 0)
     ;; strings
     ((node-is "\"") prev-sibling -1)
     ((node-is "node_field") prev-sibling 0)
     ((parent-is "string") parent 0)

     ((parent-is "node_children") grand-parent 2))))


(defun kdl-ts-setup ()
  "Setup treesit for html-ts-mode."

  (setq-local treesit-font-lock-feature-list
              '((comment delimiter node key property argument brackets)))

  (setq-local treesit-font-lock-settings
               (apply #'treesit-font-lock-rules
                    kdl-ts-font-lock-rules))

  (setq-local treesit-simple-indent-rules kdl-ts-indent-rules)
  (treesit-major-mode-setup))
