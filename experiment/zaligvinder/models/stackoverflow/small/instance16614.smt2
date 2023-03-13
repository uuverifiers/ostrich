;test regex (9[0-5][0-9]{3}|960[0-9]{2}|961[0-5][0-9]|9616[0-3])
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.++ (str.to_re "9") (re.++ (re.range "0" "5") ((_ re.loop 3 3) (re.range "0" "9")))) (re.++ (str.to_re "960") ((_ re.loop 2 2) (re.range "0" "9")))) (re.++ (str.to_re "961") (re.++ (re.range "0" "5") (re.range "0" "9")))) (re.++ (str.to_re "9616") (re.range "0" "3")))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)