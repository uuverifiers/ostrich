;test regex ^(Course) \d{1,3} (day)|(week) \d{1,3}$
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "") (re.++ (re.++ (str.to_re "C") (re.++ (str.to_re "o") (re.++ (str.to_re "u") (re.++ (str.to_re "r") (re.++ (str.to_re "s") (str.to_re "e")))))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.++ (str.to_re " ") (re.++ (str.to_re "d") (re.++ (str.to_re "a") (str.to_re "y")))))))) (re.++ (re.++ (re.++ (str.to_re "w") (re.++ (str.to_re "e") (re.++ (str.to_re "e") (str.to_re "k")))) (re.++ (str.to_re " ") ((_ re.loop 1 3) (re.range "0" "9")))) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)