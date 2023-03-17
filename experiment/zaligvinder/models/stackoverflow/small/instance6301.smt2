;test regex [\uD800-\uDBFF][\uDC00-\uDFFF](?:[\u200D\uFE0F][\uD800-\uDBFF][\uDC00-\uDFFF]){2,}
(declare-const X String)
(assert (str.in_re X (re.++ (re.range "\u{d800}" "\u{dbff}") (re.++ (re.range "\u{dc00}" "\u{dfff}") (re.++ (re.* (re.++ (re.union (str.to_re "\u{200d}") (str.to_re "\u{fe0f}")) (re.++ (re.range "\u{d800}" "\u{dbff}") (re.range "\u{dc00}" "\u{dfff}")))) ((_ re.loop 2 2) (re.++ (re.union (str.to_re "\u{200d}") (str.to_re "\u{fe0f}")) (re.++ (re.range "\u{d800}" "\u{dbff}") (re.range "\u{dc00}" "\u{dfff}")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)