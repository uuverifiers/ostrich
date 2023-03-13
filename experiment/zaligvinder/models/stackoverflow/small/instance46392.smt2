;test regex ^[A-Za-z]{3,}\.(?:pdf|doc|html)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.++ (re.* (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 3 3) (re.union (re.range "A" "Z") (re.range "a" "z")))) (re.++ (str.to_re ".") (re.union (re.union (re.++ (str.to_re "p") (re.++ (str.to_re "d") (str.to_re "f"))) (re.++ (str.to_re "d") (re.++ (str.to_re "o") (str.to_re "c")))) (re.++ (str.to_re "h") (re.++ (str.to_re "t") (re.++ (str.to_re "m") (str.to_re "l")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)