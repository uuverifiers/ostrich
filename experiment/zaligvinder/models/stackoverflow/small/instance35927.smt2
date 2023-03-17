;test regex ((?:(?:fixed|local|scroll)\s*){1,2})
(declare-const X String)
(assert (str.in_re X ((_ re.loop 1 2) (re.++ (re.union (re.union (re.++ (str.to_re "f") (re.++ (str.to_re "i") (re.++ (str.to_re "x") (re.++ (str.to_re "e") (str.to_re "d"))))) (re.++ (str.to_re "l") (re.++ (str.to_re "o") (re.++ (str.to_re "c") (re.++ (str.to_re "a") (str.to_re "l")))))) (re.++ (str.to_re "s") (re.++ (str.to_re "c") (re.++ (str.to_re "r") (re.++ (str.to_re "o") (re.++ (str.to_re "l") (str.to_re "l"))))))) (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)