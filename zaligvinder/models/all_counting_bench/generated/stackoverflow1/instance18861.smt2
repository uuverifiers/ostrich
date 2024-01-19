;test regex ^[A-HJ-NPR-Za-hj-npr-z\d]{8}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") ((_ re.loop 8 8) (re.union (re.range "A" "H") (re.union (re.range "J" "N") (re.union (str.to_re "P") (re.union (re.range "R" "Z") (re.union (re.range "a" "h") (re.union (re.range "j" "n") (re.union (str.to_re "p") (re.union (re.range "r" "z") (re.range "0" "9")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)