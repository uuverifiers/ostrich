;test regex ^([A-z]{2}\d{9}[Gg][Bb])|(\d{12})$
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "") (re.++ ((_ re.loop 2 2) (re.range "A" "z")) (re.++ ((_ re.loop 9 9) (re.range "0" "9")) (re.++ (re.union (str.to_re "G") (str.to_re "g")) (re.union (str.to_re "B") (str.to_re "b")))))) (re.++ ((_ re.loop 12 12) (re.range "0" "9")) (str.to_re "")))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)