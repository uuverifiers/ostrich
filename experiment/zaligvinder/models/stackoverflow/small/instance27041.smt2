;test regex ^(xyz|abc)(\w{3,3})(\d{0,2})(\d{2,2})(a|ab|ef)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.++ (str.to_re "x") (re.++ (str.to_re "y") (str.to_re "z"))) (re.++ (str.to_re "a") (re.++ (str.to_re "b") (str.to_re "c")))) (re.++ ((_ re.loop 3 3) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (re.++ ((_ re.loop 0 2) (re.range "0" "9")) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.union (re.union (str.to_re "a") (re.++ (str.to_re "a") (str.to_re "b"))) (re.++ (str.to_re "e") (str.to_re "f")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)