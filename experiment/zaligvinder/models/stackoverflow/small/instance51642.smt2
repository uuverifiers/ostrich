;test regex ^([A-Z][A-HJ-Y]?[0-9][A-Z0-9]? ?[0-9][A-Z]{2}|GIR ?0A{2})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.++ (re.range "A" "Z") (re.++ (re.opt (re.union (re.range "A" "H") (re.range "J" "Y"))) (re.++ (re.range "0" "9") (re.++ (re.opt (re.union (re.range "A" "Z") (re.range "0" "9"))) (re.++ (re.opt (str.to_re " ")) (re.++ (re.range "0" "9") ((_ re.loop 2 2) (re.range "A" "Z")))))))) (re.++ (str.to_re "G") (re.++ (str.to_re "I") (re.++ (str.to_re "R") (re.++ (re.opt (str.to_re " ")) (re.++ (str.to_re "0") ((_ re.loop 2 2) (str.to_re "A"))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)