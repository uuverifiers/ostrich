;test regex ^([a-zA-Z]){1}([0-9][0-9]|[0-9]|[a-zA-Z][0-9][a-zA-Z]|[a-zA-Z][0-9][0-9]|[a-zA-Z][0-9]){1}([ ])([0-9][a-zA-z][a-zA-z]){1}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ ((_ re.loop 1 1) (re.union (re.union (re.union (re.union (re.++ (re.range "0" "9") (re.range "0" "9")) (re.range "0" "9")) (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (re.++ (re.range "0" "9") (re.union (re.range "a" "z") (re.range "A" "Z"))))) (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (re.++ (re.range "0" "9") (re.range "0" "9")))) (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (re.range "0" "9")))) (re.++ (str.to_re " ") ((_ re.loop 1 1) (re.++ (re.range "0" "9") (re.++ (re.union (re.range "a" "z") (re.range "A" "z")) (re.union (re.range "a" "z") (re.range "A" "z"))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)