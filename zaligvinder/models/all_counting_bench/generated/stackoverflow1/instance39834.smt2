;test regex ^(0[1-9]|[1-8]\d|9[0-8]|2[AB])\d{3}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.union (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.range "1" "8") (re.range "0" "9"))) (re.++ (str.to_re "9") (re.range "0" "8"))) (re.++ (str.to_re "2") (re.union (str.to_re "A") (str.to_re "B")))) ((_ re.loop 3 3) (re.range "0" "9")))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)