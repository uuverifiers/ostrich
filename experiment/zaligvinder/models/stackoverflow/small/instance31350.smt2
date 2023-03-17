;test regex (([Ee][xX][pP])|[Dd][Rr][aA])\d{0,5}/\d{2}
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.++ (re.union (str.to_re "E") (str.to_re "e")) (re.++ (re.union (str.to_re "x") (str.to_re "X")) (re.union (str.to_re "p") (str.to_re "P")))) (re.++ (re.union (str.to_re "D") (str.to_re "d")) (re.++ (re.union (str.to_re "R") (str.to_re "r")) (re.union (str.to_re "a") (str.to_re "A"))))) (re.++ ((_ re.loop 0 5) (re.range "0" "9")) (re.++ (str.to_re "/") ((_ re.loop 2 2) (re.range "0" "9")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)