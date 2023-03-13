;test regex (\+989|9|09)(0[1-3]|1[0-9]|2[0-2]|3[0-9]|90|9[8-9])\d{7}
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.union (re.++ (str.to_re "+") (str.to_re "989")) (str.to_re "9")) (str.to_re "09")) (re.++ (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "0") (re.range "1" "3")) (re.++ (str.to_re "1") (re.range "0" "9"))) (re.++ (str.to_re "2") (re.range "0" "2"))) (re.++ (str.to_re "3") (re.range "0" "9"))) (str.to_re "90")) (re.++ (str.to_re "9") (re.range "8" "9"))) ((_ re.loop 7 7) (re.range "0" "9"))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)