;test regex ^\d\d(0[0-9]|1[0-9]|2[0-9]|3[0-9]|4[0-9]|5[0-2]){1}\d{5}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.++ ((_ re.loop 1 1) (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "9"))) (re.++ (str.to_re "2") (re.range "0" "9"))) (re.++ (str.to_re "3") (re.range "0" "9"))) (re.++ (str.to_re "4") (re.range "0" "9"))) (re.++ (str.to_re "5") (re.range "0" "2")))) ((_ re.loop 5 5) (re.range "0" "9")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)