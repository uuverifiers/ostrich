;test regex s/(?:^|-)x([0-9a-fA-F]{1,5})/ chr hex $1 /eg;
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "s") (re.++ (str.to_re "/") (re.++ (re.union (str.to_re "") (str.to_re "-")) (re.++ (str.to_re "x") (re.++ ((_ re.loop 1 5) (re.union (re.range "0" "9") (re.union (re.range "a" "f") (re.range "A" "F")))) (re.++ (str.to_re "/") (re.++ (str.to_re " ") (re.++ (str.to_re "c") (re.++ (str.to_re "h") (re.++ (str.to_re "r") (re.++ (str.to_re " ") (re.++ (str.to_re "h") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (str.to_re " "))))))))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "1") (re.++ (str.to_re " ") (re.++ (str.to_re "/") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (str.to_re ";"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)