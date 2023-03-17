;test regex (?:Fall|Summer|Spring|Winter)\s\d{4}
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.union (re.union (re.++ (str.to_re "F") (re.++ (str.to_re "a") (re.++ (str.to_re "l") (str.to_re "l")))) (re.++ (str.to_re "S") (re.++ (str.to_re "u") (re.++ (str.to_re "m") (re.++ (str.to_re "m") (re.++ (str.to_re "e") (str.to_re "r"))))))) (re.++ (str.to_re "S") (re.++ (str.to_re "p") (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (str.to_re "g"))))))) (re.++ (str.to_re "W") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (str.to_re "r"))))))) (re.++ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) ((_ re.loop 4 4) (re.range "0" "9"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)