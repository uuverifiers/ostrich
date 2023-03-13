;test regex 1{1}2{1}3{1}4{1}5{1}
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (str.to_re "1")) (re.++ ((_ re.loop 1 1) (str.to_re "2")) (re.++ ((_ re.loop 1 1) (str.to_re "3")) (re.++ ((_ re.loop 1 1) (str.to_re "4")) ((_ re.loop 1 1) (str.to_re "5"))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)