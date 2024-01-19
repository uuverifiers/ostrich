;test regex ^((0[^0]{10,14})|([1-9][0-9]{10,14}))$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.++ (str.to_re "0") ((_ re.loop 10 14) (re.diff re.allchar (str.to_re "0")))) (re.++ (re.range "1" "9") ((_ re.loop 10 14) (re.range "0" "9"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)