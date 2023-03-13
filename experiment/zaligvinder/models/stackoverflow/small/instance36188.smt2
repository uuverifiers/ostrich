;test regex \r\n\u001B\[1;14H(X[0-9]{5})
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{0d}") (re.++ (str.to_re "\u{0a}") (re.++ (str.to_re "\u{001b}") (re.++ (str.to_re "[") (re.++ (str.to_re "1") (re.++ (str.to_re ";") (re.++ (str.to_re "14") (re.++ (str.to_re "H") (re.++ (str.to_re "X") ((_ re.loop 5 5) (re.range "0" "9")))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)