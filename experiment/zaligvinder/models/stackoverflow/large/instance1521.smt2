;test regex ^(AB[a-zA-Z0-9]{20})$|^(AB[a-zA-Z0-9]{0,19}|AB[a-zA-Z0-9]{21,})$|^([^A][^B][a-zA-Z0-9]{20})$
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "A") (re.++ (str.to_re "B") ((_ re.loop 20 20) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9"))))))) (str.to_re "")) (re.++ (re.++ (str.to_re "") (re.union (re.++ (str.to_re "A") (re.++ (str.to_re "B") ((_ re.loop 0 19) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9")))))) (re.++ (str.to_re "A") (re.++ (str.to_re "B") (re.++ (re.* (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9")))) ((_ re.loop 21 21) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9"))))))))) (str.to_re ""))) (re.++ (re.++ (str.to_re "") (re.++ (re.diff re.allchar (str.to_re "A")) (re.++ (re.diff re.allchar (str.to_re "B")) ((_ re.loop 20 20) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9"))))))) (str.to_re "")))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)