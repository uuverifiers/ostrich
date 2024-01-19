;test regex ^[A-HJ-NPR-Z\\d]{8}[\\dX][A-HJ-NPR-Z\\d]{2}\\d{6}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 8 8) (re.union (re.range "A" "H") (re.union (re.range "J" "N") (re.union (str.to_re "P") (re.union (re.range "R" "Z") (re.union (str.to_re "\\") (str.to_re "d"))))))) (re.++ (re.union (str.to_re "\\") (re.union (str.to_re "d") (str.to_re "X"))) (re.++ ((_ re.loop 2 2) (re.union (re.range "A" "H") (re.union (re.range "J" "N") (re.union (str.to_re "P") (re.union (re.range "R" "Z") (re.union (str.to_re "\\") (str.to_re "d"))))))) (re.++ (str.to_re "\\") ((_ re.loop 6 6) (str.to_re "d"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)