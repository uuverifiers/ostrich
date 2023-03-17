;test regex ^5[1-5]\d{14}$|^2(?:2(?:2[1-9]|[3-9]\d)|[3-6]\d\d|7(?:[01]\d|20))\d{12}$
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "5") (re.++ (re.range "1" "5") ((_ re.loop 14 14) (re.range "0" "9"))))) (str.to_re "")) (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "2") (re.++ (re.union (re.union (re.++ (str.to_re "2") (re.union (re.++ (str.to_re "2") (re.range "1" "9")) (re.++ (re.range "3" "9") (re.range "0" "9")))) (re.++ (re.range "3" "6") (re.++ (re.range "0" "9") (re.range "0" "9")))) (re.++ (str.to_re "7") (re.union (re.++ (str.to_re "01") (re.range "0" "9")) (str.to_re "20")))) ((_ re.loop 12 12) (re.range "0" "9"))))) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)