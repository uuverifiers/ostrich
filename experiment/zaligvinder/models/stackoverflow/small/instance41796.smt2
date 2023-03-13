;test regex (201[0-7]|200[0-9]|[0-1][0-9]{3})(1[0-2]|0[1-9])(3[01]|[0-2][1-9]|[12]0)
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.union (re.++ (str.to_re "201") (re.range "0" "7")) (re.++ (str.to_re "200") (re.range "0" "9"))) (re.++ (re.range "0" "1") ((_ re.loop 3 3) (re.range "0" "9")))) (re.++ (re.union (re.++ (str.to_re "1") (re.range "0" "2")) (re.++ (str.to_re "0") (re.range "1" "9"))) (re.union (re.union (re.++ (str.to_re "3") (str.to_re "01")) (re.++ (re.range "0" "2") (re.range "1" "9"))) (re.++ (str.to_re "12") (str.to_re "0")))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)