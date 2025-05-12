;; Allow selecting jsx ekements

(jsx_element
  [
    (jsx_element) @function.inside
    (jsx_text) @function.inside]+ @function.around)
; [
;   (jsx_text)
;   (jsx_element)] @function.inside @entry.inside

; inherits: _javascript,ecma
