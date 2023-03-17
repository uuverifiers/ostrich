;test regex ^(961(3|70|71)|(03|70|71))\d{6}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.++ (str.to_re "961") (re.union (re.union (str.to_re "3") (str.to_re "70")) (str.to_re "71"))) (re.union (re.union (str.to_re "03") (str.to_re "70")) (str.to_re "71"))) ((_ re.loop 6 6) (re.range "0" "9")))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)