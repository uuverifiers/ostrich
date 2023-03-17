;test regex ((0[1-9]|[1-2][0-9])02|(0[1-9]|[1-2][0-9]|30)(0[469]|11)|(0[1-9]|[1-2][0-9]|3[01])(0[13578]|1[02]))[0-9]{2}
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.union (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.range "1" "2") (re.range "0" "9"))) (str.to_re "02")) (re.++ (re.union (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.range "1" "2") (re.range "0" "9"))) (str.to_re "30")) (re.union (re.++ (str.to_re "0") (str.to_re "469")) (str.to_re "11")))) (re.++ (re.union (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.range "1" "2") (re.range "0" "9"))) (re.++ (str.to_re "3") (str.to_re "01"))) (re.union (re.++ (str.to_re "0") (str.to_re "13578")) (re.++ (str.to_re "1") (str.to_re "02"))))) ((_ re.loop 2 2) (re.range "0" "9")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)