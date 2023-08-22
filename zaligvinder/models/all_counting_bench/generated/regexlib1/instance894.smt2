;test regex (0[289][0-9]{2})|([1345689][0-9]{3})|(2[0-8][0-9]{2})|(290[0-9])|(291[0-4])|(7[0-4][0-9]{2})|(7[8-9][0-9]{2})
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "0") (re.++ (str.to_re "289") ((_ re.loop 2 2) (re.range "0" "9")))) (re.++ (str.to_re "1345689") ((_ re.loop 3 3) (re.range "0" "9")))) (re.++ (str.to_re "2") (re.++ (re.range "0" "8") ((_ re.loop 2 2) (re.range "0" "9"))))) (re.++ (str.to_re "290") (re.range "0" "9"))) (re.++ (str.to_re "291") (re.range "0" "4"))) (re.++ (str.to_re "7") (re.++ (re.range "0" "4") ((_ re.loop 2 2) (re.range "0" "9"))))) (re.++ (str.to_re "7") (re.++ (re.range "8" "9") ((_ re.loop 2 2) (re.range "0" "9")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)