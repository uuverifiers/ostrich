;test regex (&amp|\?)sid=[0-9a-f]{32}&amp
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "&") (re.++ (str.to_re "a") (re.++ (str.to_re "m") (str.to_re "p")))) (str.to_re "?")) (re.++ (str.to_re "s") (re.++ (str.to_re "i") (re.++ (str.to_re "d") (re.++ (str.to_re "=") (re.++ ((_ re.loop 32 32) (re.union (re.range "0" "9") (re.range "a" "f"))) (re.++ (str.to_re "&") (re.++ (str.to_re "a") (re.++ (str.to_re "m") (str.to_re "p"))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)