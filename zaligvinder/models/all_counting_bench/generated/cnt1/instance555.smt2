;test regex ^(tree|object) ([a-fA-F0-9]{40})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (str.to_re "e")))) (re.++ (str.to_re "o") (re.++ (str.to_re "b") (re.++ (str.to_re "j") (re.++ (str.to_re "e") (re.++ (str.to_re "c") (str.to_re "t"))))))) (re.++ (str.to_re " ") ((_ re.loop 40 40) (re.union (re.range "a" "f") (re.union (re.range "A" "F") (re.range "0" "9"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)