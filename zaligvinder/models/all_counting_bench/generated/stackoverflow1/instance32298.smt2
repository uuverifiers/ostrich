;test regex ^5[1-5][0-9]{0,14}|^(222[1-9]|2[3-6]\\d{2}|27[0-1]\\d|2720)[0-9]{0,12}
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "") (re.++ (str.to_re "5") (re.++ (re.range "1" "5") ((_ re.loop 0 14) (re.range "0" "9"))))) (re.++ (str.to_re "") (re.++ (re.union (re.union (re.union (re.++ (str.to_re "222") (re.range "1" "9")) (re.++ (str.to_re "2") (re.++ (re.range "3" "6") (re.++ (str.to_re "\\") ((_ re.loop 2 2) (str.to_re "d")))))) (re.++ (str.to_re "27") (re.++ (re.range "0" "1") (re.++ (str.to_re "\\") (str.to_re "d"))))) (str.to_re "2720")) ((_ re.loop 0 12) (re.range "0" "9")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)