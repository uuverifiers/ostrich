;test regex S[0-9]{7}[A-Z]{1,2}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "S") (re.++ ((_ re.loop 7 7) (re.range "0" "9")) ((_ re.loop 1 2) (re.range "A" "Z"))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)