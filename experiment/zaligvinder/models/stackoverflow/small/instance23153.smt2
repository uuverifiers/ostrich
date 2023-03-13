;test regex ^(5018|5020|5038|6304|6759|6761|6763)[0-9]{8,15}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.union (re.union (re.union (re.union (re.union (str.to_re "5018") (str.to_re "5020")) (str.to_re "5038")) (str.to_re "6304")) (str.to_re "6759")) (str.to_re "6761")) (str.to_re "6763")) ((_ re.loop 8 15) (re.range "0" "9")))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)