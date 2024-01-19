;test regex ^(?:(?:00|\+)58)(?:4(?:1[246]|2[46]))\d{7}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.++ (re.union (str.to_re "00") (str.to_re "+")) (str.to_re "58")) (re.++ (re.++ (str.to_re "4") (re.union (re.++ (str.to_re "1") (str.to_re "246")) (re.++ (str.to_re "2") (str.to_re "46")))) ((_ re.loop 7 7) (re.range "0" "9"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)