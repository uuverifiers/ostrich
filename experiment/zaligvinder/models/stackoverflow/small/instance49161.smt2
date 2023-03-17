;test regex ([1-9][0-9]{0,2}|1[0-8][0-9]{2}|19[0-8][0-9]|199[0-8])
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.++ (re.range "1" "9") ((_ re.loop 0 2) (re.range "0" "9"))) (re.++ (str.to_re "1") (re.++ (re.range "0" "8") ((_ re.loop 2 2) (re.range "0" "9"))))) (re.++ (str.to_re "19") (re.++ (re.range "0" "8") (re.range "0" "9")))) (re.++ (str.to_re "199") (re.range "0" "8")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)