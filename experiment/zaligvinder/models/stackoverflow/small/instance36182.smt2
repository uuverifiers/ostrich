;test regex ^(?:[A-Za-z0-9]{10}|[A-Za-z0-9]{12}|[A-Za-z0-9]{25})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union ((_ re.loop 10 10) (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9")))) ((_ re.loop 12 12) (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9"))))) ((_ re.loop 25 25) (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)