;test regex radius\K[0-9]{1,2}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "r") (re.++ (str.to_re "a") (re.++ (str.to_re "d") (re.++ (str.to_re "i") (re.++ (str.to_re "u") (re.++ (str.to_re "s") (re.++ (str.to_re "K") ((_ re.loop 1 2) (re.range "0" "9")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)