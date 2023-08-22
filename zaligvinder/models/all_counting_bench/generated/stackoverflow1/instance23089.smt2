;test regex ^(11[0-9]{2}|10[1-9]{2}|10[2-9]0)\s*([A-Z]{2}|[a-z]{2})
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.union (re.union (re.++ (str.to_re "11") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "10") ((_ re.loop 2 2) (re.range "1" "9")))) (re.++ (str.to_re "10") (re.++ (re.range "2" "9") (str.to_re "0")))) (re.++ (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.union ((_ re.loop 2 2) (re.range "A" "Z")) ((_ re.loop 2 2) (re.range "a" "z"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)