;test regex X00(X01((P00){1}(T00){1,99}){1,9999}H00)V99
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "X") (re.++ (str.to_re "00") (re.++ (re.++ (str.to_re "X") (re.++ (str.to_re "01") (re.++ ((_ re.loop 1 9999) (re.++ ((_ re.loop 1 1) (re.++ (str.to_re "P") (str.to_re "00"))) ((_ re.loop 1 99) (re.++ (str.to_re "T") (str.to_re "00"))))) (re.++ (str.to_re "H") (str.to_re "00"))))) (re.++ (str.to_re "V") (str.to_re "99")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)