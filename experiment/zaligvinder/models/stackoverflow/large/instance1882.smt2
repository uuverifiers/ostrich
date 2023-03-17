;test regex ^(?:\+(?:[0-9]{12}|[0-9]{10}|[0-9]{7})|(?:[0-9]{13}|[0-9]{11}|[0-9]{8}))$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.++ (str.to_re "+") (re.union (re.union ((_ re.loop 12 12) (re.range "0" "9")) ((_ re.loop 10 10) (re.range "0" "9"))) ((_ re.loop 7 7) (re.range "0" "9")))) (re.union (re.union ((_ re.loop 13 13) (re.range "0" "9")) ((_ re.loop 11 11) (re.range "0" "9"))) ((_ re.loop 8 8) (re.range "0" "9"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)