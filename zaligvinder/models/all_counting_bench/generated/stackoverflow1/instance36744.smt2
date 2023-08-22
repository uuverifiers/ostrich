;test regex ^(101[3-9]|10[2-9][0-9]|1[1-9][0-9]{2}|[23][0-9]{3}|40[0-3][0-9]|404[0-4])$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "101") (re.range "3" "9")) (re.++ (str.to_re "10") (re.++ (re.range "2" "9") (re.range "0" "9")))) (re.++ (str.to_re "1") (re.++ (re.range "1" "9") ((_ re.loop 2 2) (re.range "0" "9"))))) (re.++ (str.to_re "23") ((_ re.loop 3 3) (re.range "0" "9")))) (re.++ (str.to_re "40") (re.++ (re.range "0" "3") (re.range "0" "9")))) (re.++ (str.to_re "404") (re.range "0" "4")))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)