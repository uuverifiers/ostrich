;test regex ^(ABCD|HIJK)\\d{4}_
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.union (re.++ (str.to_re "A") (re.++ (str.to_re "B") (re.++ (str.to_re "C") (str.to_re "D")))) (re.++ (str.to_re "H") (re.++ (str.to_re "I") (re.++ (str.to_re "J") (str.to_re "K"))))) (re.++ (str.to_re "\\") (re.++ ((_ re.loop 4 4) (str.to_re "d")) (str.to_re "_")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)