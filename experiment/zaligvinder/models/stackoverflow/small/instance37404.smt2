;test regex ^(([a-zA-Z]{4}[ ]{0,1}){0,6}([a-zA-Z]{0,4})|([a-zA-Z]{4}))$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.++ ((_ re.loop 0 6) (re.++ ((_ re.loop 4 4) (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 0 1) (str.to_re " ")))) ((_ re.loop 0 4) (re.union (re.range "a" "z") (re.range "A" "Z")))) ((_ re.loop 4 4) (re.union (re.range "a" "z") (re.range "A" "Z"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)