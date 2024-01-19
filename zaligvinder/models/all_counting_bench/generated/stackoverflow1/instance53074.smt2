;test regex ^(MID\d{6}|MID\d{3}000|0MID\d{5}|00MID\d{4})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union (re.union (re.++ (str.to_re "M") (re.++ (str.to_re "I") (re.++ (str.to_re "D") ((_ re.loop 6 6) (re.range "0" "9"))))) (re.++ (str.to_re "M") (re.++ (str.to_re "I") (re.++ (str.to_re "D") (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "000")))))) (re.++ (str.to_re "0") (re.++ (str.to_re "M") (re.++ (str.to_re "I") (re.++ (str.to_re "D") ((_ re.loop 5 5) (re.range "0" "9"))))))) (re.++ (str.to_re "00") (re.++ (str.to_re "M") (re.++ (str.to_re "I") (re.++ (str.to_re "D") ((_ re.loop 4 4) (re.range "0" "9")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)