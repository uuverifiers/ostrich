;test regex ObjectID\((\"[a-zA-Z0-9]{15,}\")\)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "O") (re.++ (str.to_re "b") (re.++ (str.to_re "j") (re.++ (str.to_re "e") (re.++ (str.to_re "c") (re.++ (str.to_re "t") (re.++ (str.to_re "I") (re.++ (str.to_re "D") (re.++ (str.to_re "(") (re.++ (re.++ (str.to_re "\u{22}") (re.++ (re.++ (re.* (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9")))) ((_ re.loop 15 15) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9"))))) (str.to_re "\u{22}"))) (str.to_re ")")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)