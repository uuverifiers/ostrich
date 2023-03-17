;test regex ^\+(?:(?:91)|(?:49)|(?:3(?:52)|3|2))\d{8,15}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (str.to_re "+") (re.++ (re.union (re.union (str.to_re "91") (str.to_re "49")) (re.union (re.union (re.++ (str.to_re "3") (str.to_re "52")) (str.to_re "3")) (str.to_re "2"))) ((_ re.loop 8 15) (re.range "0" "9")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)