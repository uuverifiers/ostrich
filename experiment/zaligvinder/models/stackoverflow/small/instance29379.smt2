;test regex ^0(1|2|3|4|5|9){1,1}[0-9]{8,8}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (str.to_re "0") (re.++ ((_ re.loop 1 1) (re.union (re.union (re.union (re.union (re.union (str.to_re "1") (str.to_re "2")) (str.to_re "3")) (str.to_re "4")) (str.to_re "5")) (str.to_re "9"))) ((_ re.loop 8 8) (re.range "0" "9")))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)