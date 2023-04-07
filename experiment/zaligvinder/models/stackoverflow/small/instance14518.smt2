;test regex \d{5}(?:[-\s]\d{4})?\nUnited States
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (re.++ (re.opt (re.++ (re.union (str.to_re "-") (re.union (str.to_re "\u{20}") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) ((_ re.loop 4 4) (re.range "0" "9")))) (re.++ (str.to_re "\u{0a}") (re.++ (str.to_re "U") (re.++ (str.to_re "n") (re.++ (str.to_re "i") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "d") (re.++ (str.to_re " ") (re.++ (str.to_re "S") (re.++ (str.to_re "t") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (str.to_re "s"))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)