;test regex ^10[0|2-9]{1}0*([1-9]|1[0-6])0*([1-9]|[12][0-9]|3[0-6])0*([1-9][0-9]|1[0-2][0-9])0*([1-9]|[12][0-9]|3[0-6])W[1-6]0[0-9]$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "10") (re.++ ((_ re.loop 1 1) (re.union (str.to_re "0") (re.union (str.to_re "|") (re.range "2" "9")))) (re.++ (re.* (str.to_re "0")) (re.++ (re.union (re.range "1" "9") (re.++ (str.to_re "1") (re.range "0" "6"))) (re.++ (re.* (str.to_re "0")) (re.++ (re.union (re.union (re.range "1" "9") (re.++ (str.to_re "12") (re.range "0" "9"))) (re.++ (str.to_re "3") (re.range "0" "6"))) (re.++ (re.* (str.to_re "0")) (re.++ (re.union (re.++ (re.range "1" "9") (re.range "0" "9")) (re.++ (str.to_re "1") (re.++ (re.range "0" "2") (re.range "0" "9")))) (re.++ (re.* (str.to_re "0")) (re.++ (re.union (re.union (re.range "1" "9") (re.++ (str.to_re "12") (re.range "0" "9"))) (re.++ (str.to_re "3") (re.range "0" "6"))) (re.++ (str.to_re "W") (re.++ (re.range "1" "6") (re.++ (str.to_re "0") (re.range "0" "9"))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)