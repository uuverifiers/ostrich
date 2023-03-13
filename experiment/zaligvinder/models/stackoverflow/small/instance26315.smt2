;test regex ^TB\d{8}([^C]|$)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (str.to_re "T") (re.++ (str.to_re "B") (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (re.union (re.diff re.allchar (str.to_re "C")) (str.to_re ""))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)