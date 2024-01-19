;test regex (^(256[0-9]{9})|^(078|077|071|079)[0-9]{8})
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "") (re.++ (str.to_re "256") ((_ re.loop 9 9) (re.range "0" "9")))) (re.++ (str.to_re "") (re.++ (re.union (re.union (re.union (str.to_re "078") (str.to_re "077")) (str.to_re "071")) (str.to_re "079")) ((_ re.loop 8 8) (re.range "0" "9")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)