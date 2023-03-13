;test regex \A[a-z](?:[a-z]\d{6}|\d{6}[a-z])\z
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "A") (re.++ (re.range "a" "z") (re.++ (re.union (re.++ (re.range "a" "z") ((_ re.loop 6 6) (re.range "0" "9"))) (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (re.range "a" "z"))) (str.to_re "z"))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)