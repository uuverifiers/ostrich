;test regex ^(5[1-5][0-9]{14}|2(22[1-9][0-9]{12}|2[3-9][0-9]{13}|[3-6][0-9]{14}|7[0-1][0-9]{13}|720[0-9]{12}))$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.++ (str.to_re "5") (re.++ (re.range "1" "5") ((_ re.loop 14 14) (re.range "0" "9")))) (re.++ (str.to_re "2") (re.union (re.union (re.union (re.union (re.++ (str.to_re "22") (re.++ (re.range "1" "9") ((_ re.loop 12 12) (re.range "0" "9")))) (re.++ (str.to_re "2") (re.++ (re.range "3" "9") ((_ re.loop 13 13) (re.range "0" "9"))))) (re.++ (re.range "3" "6") ((_ re.loop 14 14) (re.range "0" "9")))) (re.++ (str.to_re "7") (re.++ (re.range "0" "1") ((_ re.loop 13 13) (re.range "0" "9"))))) (re.++ (str.to_re "720") ((_ re.loop 12 12) (re.range "0" "9"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)