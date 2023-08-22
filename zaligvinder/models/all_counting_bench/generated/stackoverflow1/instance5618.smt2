;test regex ^(0{0,2}[0-9]|0?[1-9][0-9]|1[0-7][0-9]|180)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union (re.union (re.++ ((_ re.loop 0 2) (str.to_re "0")) (re.range "0" "9")) (re.++ (re.opt (str.to_re "0")) (re.++ (re.range "1" "9") (re.range "0" "9")))) (re.++ (str.to_re "1") (re.++ (re.range "0" "7") (re.range "0" "9")))) (str.to_re "180"))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)