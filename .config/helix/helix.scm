(require (prefix-in helix. "helix/commands.scm"))
(require (prefix-in helix.static. "helix/static.scm"))
(require "helix/editor.scm")

(require "helix/misc.scm")
(require "mattwparas-helix-package/cogs/package.scm")
(require "mattwparas-helix-package/helix.scm")


(provide my-shell eval-code)

(define (current-path)
  (let* ([focus (editor-focus)]
         [focus-doc-id (editor->doc-id focus)])
    (editor-document->path focus-doc-id)))

(define (eval-code . args)
  (if (> (length args) 0)
      (let* ([input (string-join args " ")]
             [expr (read (open-input-string input))])
            (eval expr))
      (load-package (current-path))))

;;@doc
;; Runs a shell command but expands special stuff:
;; - `%`: current open file
(define (my-shell . args)
  (let ([expanded
        (map (lambda (x)
               (if (equal? x "%")
                   (current-path)
                   x))
             args)])
    (apply helix.run-shell-command expanded)))
