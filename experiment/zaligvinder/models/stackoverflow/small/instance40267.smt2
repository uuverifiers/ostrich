;test regex RH\s\d{2}|\(RH\s\d{2} \+ \d{2}\)
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "R") (re.++ (str.to_re "H") (re.++ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) ((_ re.loop 2 2) (re.range "0" "9"))))) (re.++ (str.to_re "(") (re.++ (str.to_re "R") (re.++ (str.to_re "H") (re.++ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re " ") (re.++ (str.to_re "+") (re.++ (str.to_re " ") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re ")")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)