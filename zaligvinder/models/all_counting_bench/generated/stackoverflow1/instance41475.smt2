;test regex cid=30000(19[5-9]|[2-3]\d{2}|4[0-2]\d)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "c") (re.++ (str.to_re "i") (re.++ (str.to_re "d") (re.++ (str.to_re "=") (re.++ (str.to_re "30000") (re.union (re.union (re.++ (str.to_re "19") (re.range "5" "9")) (re.++ (re.range "2" "3") ((_ re.loop 2 2) (re.range "0" "9")))) (re.++ (str.to_re "4") (re.++ (re.range "0" "2") (re.range "0" "9")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)