;test regex ^(0[1-9][0-9]{0,3}|00[1-9][0-9]{0,2}|000[1-9][0-9]{0,1}|0000[1-9]|[1-9][0-9]{0,4})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union (re.union (re.union (re.++ (str.to_re "0") (re.++ (re.range "1" "9") ((_ re.loop 0 3) (re.range "0" "9")))) (re.++ (str.to_re "00") (re.++ (re.range "1" "9") ((_ re.loop 0 2) (re.range "0" "9"))))) (re.++ (str.to_re "000") (re.++ (re.range "1" "9") ((_ re.loop 0 1) (re.range "0" "9"))))) (re.++ (str.to_re "0000") (re.range "1" "9"))) (re.++ (re.range "1" "9") ((_ re.loop 0 4) (re.range "0" "9"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)