;test regex ^(?:[a-zA-Z]{2}|[a-zA-Z]{4}|[a-zA-Z]{6})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 4 4) (re.union (re.range "a" "z") (re.range "A" "Z")))) ((_ re.loop 6 6) (re.union (re.range "a" "z") (re.range "A" "Z"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)