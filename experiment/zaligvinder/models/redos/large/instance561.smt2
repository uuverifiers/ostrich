;test regex ^(ff){16}011b01040064007801010101fe(ab){254}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 16 16) (re.++ (str.to_re "f") (str.to_re "f"))) (re.++ (str.to_re "011") (re.++ (str.to_re "b") (re.++ (str.to_re "01040064007801010101") (re.++ (str.to_re "f") (re.++ (str.to_re "e") ((_ re.loop 254 254) (re.++ (str.to_re "a") (str.to_re "b")))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)