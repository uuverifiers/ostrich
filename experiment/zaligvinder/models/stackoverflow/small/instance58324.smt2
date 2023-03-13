;test regex /\/main\/sections(\/)([a-zA-z]{1}[a-zA-z\-]{0,48}[a-zA-z]{1})?/g
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "/") (re.++ (str.to_re "/") (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "/") (re.++ (str.to_re "s") (re.++ (str.to_re "e") (re.++ (str.to_re "c") (re.++ (str.to_re "t") (re.++ (str.to_re "i") (re.++ (str.to_re "o") (re.++ (str.to_re "n") (re.++ (str.to_re "s") (re.++ (str.to_re "/") (re.++ (re.opt (re.++ ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.range "A" "z"))) (re.++ ((_ re.loop 0 48) (re.union (re.range "a" "z") (re.union (re.range "A" "z") (str.to_re "-")))) ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.range "A" "z")))))) (re.++ (str.to_re "/") (str.to_re "g")))))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)