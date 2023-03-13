;test regex X01\nX02\n(N{3}(\nL{3}){1,99}\n){1,3}T01\nT02
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "X") (re.++ (str.to_re "01") (re.++ (str.to_re "\u{0a}") (re.++ (str.to_re "X") (re.++ (str.to_re "02") (re.++ (str.to_re "\u{0a}") (re.++ ((_ re.loop 1 3) (re.++ ((_ re.loop 3 3) (str.to_re "N")) (re.++ ((_ re.loop 1 99) (re.++ (str.to_re "\u{0a}") ((_ re.loop 3 3) (str.to_re "L")))) (str.to_re "\u{0a}")))) (re.++ (str.to_re "T") (re.++ (str.to_re "01") (re.++ (str.to_re "\u{0a}") (re.++ (str.to_re "T") (str.to_re "02"))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)