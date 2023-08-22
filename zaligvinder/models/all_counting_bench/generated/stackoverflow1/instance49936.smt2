;test regex ^[gG][yY][1-9]{1}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.union (str.to_re "g") (str.to_re "G")) (re.++ (re.union (str.to_re "y") (str.to_re "Y")) ((_ re.loop 1 1) (re.range "1" "9")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)