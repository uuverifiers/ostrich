;test regex size='0x[0-9a-fA-F]{4,}'
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "s") (re.++ (str.to_re "i") (re.++ (str.to_re "z") (re.++ (str.to_re "e") (re.++ (str.to_re "=") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "0") (re.++ (str.to_re "x") (re.++ (re.++ (re.* (re.union (re.range "0" "9") (re.union (re.range "a" "f") (re.range "A" "F")))) ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.union (re.range "a" "f") (re.range "A" "F"))))) (str.to_re "\u{27}"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)