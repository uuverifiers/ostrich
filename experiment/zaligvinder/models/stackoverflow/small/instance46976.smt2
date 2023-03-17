;test regex (cat|dog|bird)(\s*.){0,30}\s*(\dlbs)
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.union (re.++ (str.to_re "c") (re.++ (str.to_re "a") (str.to_re "t"))) (re.++ (str.to_re "d") (re.++ (str.to_re "o") (str.to_re "g")))) (re.++ (str.to_re "b") (re.++ (str.to_re "i") (re.++ (str.to_re "r") (str.to_re "d"))))) (re.++ ((_ re.loop 0 30) (re.++ (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.diff re.allchar (str.to_re "\n")))) (re.++ (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ (re.range "0" "9") (re.++ (str.to_re "l") (re.++ (str.to_re "b") (str.to_re "s")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)