;test regex (172)\.(1[6-9]|2[0-9]|3[0-1])(\.([2][0-5][0-5]|[1][0-9][0-9]|[1-9][0-9]|[0-9])){2}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "172") (re.++ (str.to_re ".") (re.++ (re.union (re.union (re.++ (str.to_re "1") (re.range "6" "9")) (re.++ (str.to_re "2") (re.range "0" "9"))) (re.++ (str.to_re "3") (re.range "0" "1"))) ((_ re.loop 2 2) (re.++ (str.to_re ".") (re.union (re.union (re.union (re.++ (str.to_re "2") (re.++ (re.range "0" "5") (re.range "0" "5"))) (re.++ (str.to_re "1") (re.++ (re.range "0" "9") (re.range "0" "9")))) (re.++ (re.range "1" "9") (re.range "0" "9"))) (re.range "0" "9")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)