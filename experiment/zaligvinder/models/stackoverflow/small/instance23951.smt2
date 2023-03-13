;test regex (B|b|l3|I3|i3)[0oO]{2}
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.union (re.union (re.union (str.to_re "B") (str.to_re "b")) (re.++ (str.to_re "l") (str.to_re "3"))) (re.++ (str.to_re "I") (str.to_re "3"))) (re.++ (str.to_re "i") (str.to_re "3"))) ((_ re.loop 2 2) (re.union (str.to_re "0") (re.union (str.to_re "o") (str.to_re "O")))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)