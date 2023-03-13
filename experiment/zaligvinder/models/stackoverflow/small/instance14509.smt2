;test regex ^([0-2]\d|3[0-1]|[1-9])\-(0\d|1[0-2]|[1-9])\-(2\d{2}[1-9]|2\d[1-9]0|[3-9]\d{3}|\d{2,}\d{3})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.union (re.++ (re.range "0" "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) (re.range "1" "9")) (re.++ (str.to_re "-") (re.++ (re.union (re.union (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (re.range "1" "9")) (re.++ (str.to_re "-") (re.union (re.union (re.union (re.++ (str.to_re "2") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.range "1" "9"))) (re.++ (str.to_re "2") (re.++ (re.range "0" "9") (re.++ (re.range "1" "9") (str.to_re "0"))))) (re.++ (re.range "3" "9") ((_ re.loop 3 3) (re.range "0" "9")))) (re.++ (re.++ (re.* (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9"))) ((_ re.loop 3 3) (re.range "0" "9"))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)