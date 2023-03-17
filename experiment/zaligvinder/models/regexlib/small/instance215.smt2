;test regex ^([A-Z&#209;\u{26}]{3,4}([0-9]{2})(0[1-9]|1[0-2])(0[1-9]|1[0-9]|2[0-9]|3[0-1])[A-Z|\d]{3})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 3 4) (re.union (re.range "A" "Z") (re.union (str.to_re "&") (re.union (str.to_re "#") (re.union (str.to_re "209") (re.union (str.to_re ";") (str.to_re "\u{26}"))))))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (re.++ (re.union (re.union (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "9"))) (re.++ (str.to_re "2") (re.range "0" "9"))) (re.++ (str.to_re "3") (re.range "0" "1"))) ((_ re.loop 3 3) (re.union (re.range "A" "Z") (re.union (str.to_re "|") (re.range "0" "9"))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)