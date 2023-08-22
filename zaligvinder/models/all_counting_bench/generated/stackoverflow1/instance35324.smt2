;test regex ^[a-z0-9._%+-]+@[a-z0-9.-]+\.(?:[a-z]{2}|edu|gov|mil)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.+ (re.union (re.range "a" "z") (re.union (re.range "0" "9") (re.union (str.to_re ".") (re.union (str.to_re "_") (re.union (str.to_re "%") (re.union (str.to_re "+") (str.to_re "-")))))))) (re.++ (str.to_re "@") (re.++ (re.+ (re.union (re.range "a" "z") (re.union (re.range "0" "9") (re.union (str.to_re ".") (str.to_re "-"))))) (re.++ (str.to_re ".") (re.union (re.union (re.union ((_ re.loop 2 2) (re.range "a" "z")) (re.++ (str.to_re "e") (re.++ (str.to_re "d") (str.to_re "u")))) (re.++ (str.to_re "g") (re.++ (str.to_re "o") (str.to_re "v")))) (re.++ (str.to_re "m") (re.++ (str.to_re "i") (str.to_re "l"))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)