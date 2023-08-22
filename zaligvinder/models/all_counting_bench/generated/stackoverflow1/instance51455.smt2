;test regex \D{3}\d{3}\s?-\s?(LAB|(EN(LH)?\d{1}))$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ ((_ re.loop 3 3) (re.diff re.allchar (re.range "0" "9"))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (re.opt (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ (str.to_re "-") (re.++ (re.opt (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.union (re.++ (str.to_re "L") (re.++ (str.to_re "A") (str.to_re "B"))) (re.++ (str.to_re "E") (re.++ (str.to_re "N") (re.++ (re.opt (re.++ (str.to_re "L") (str.to_re "H"))) ((_ re.loop 1 1) (re.range "0" "9"))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)