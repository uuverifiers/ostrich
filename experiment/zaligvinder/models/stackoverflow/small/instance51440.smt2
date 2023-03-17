;test regex ([0-9]{1,5}|1[0-9]{5}|2(0[0-9]{4}|1([0-3][0-9]{3}|4([0-6][0-9]{2}|7([0-3][0-9]|4[0-7])))))
(declare-const X String)
(assert (str.in_re X (re.union (re.union ((_ re.loop 1 5) (re.range "0" "9")) (re.++ (str.to_re "1") ((_ re.loop 5 5) (re.range "0" "9")))) (re.++ (str.to_re "2") (re.union (re.++ (str.to_re "0") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (str.to_re "1") (re.union (re.++ (re.range "0" "3") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (str.to_re "4") (re.union (re.++ (re.range "0" "6") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "7") (re.union (re.++ (re.range "0" "3") (re.range "0" "9")) (re.++ (str.to_re "4") (re.range "0" "7")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)