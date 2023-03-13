;test regex ^(1[01]{3}|01[01]{2}|001[01]|0001)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union (re.union (re.++ (str.to_re "1") ((_ re.loop 3 3) (str.to_re "01"))) (re.++ (str.to_re "01") ((_ re.loop 2 2) (str.to_re "01")))) (re.++ (str.to_re "001") (str.to_re "01"))) (str.to_re "0001"))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)