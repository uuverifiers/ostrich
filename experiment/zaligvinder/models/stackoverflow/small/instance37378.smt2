;test regex ^(?:5[1-5][0-9]{2}|222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720)[0-9]{12}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "5") (re.++ (re.range "1" "5") ((_ re.loop 2 2) (re.range "0" "9")))) (re.++ (str.to_re "222") (re.range "1" "9"))) (re.++ (str.to_re "22") (re.++ (re.range "3" "9") (re.range "0" "9")))) (re.++ (str.to_re "2") (re.++ (re.range "3" "6") ((_ re.loop 2 2) (re.range "0" "9"))))) (re.++ (str.to_re "27") (re.++ (str.to_re "01") (re.range "0" "9")))) (str.to_re "2720")) ((_ re.loop 12 12) (re.range "0" "9")))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)