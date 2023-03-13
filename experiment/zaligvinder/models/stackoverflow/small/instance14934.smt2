;test regex ^20120(7(1[5-9]|2\d|3[01])|8([0-1]\d|20))\d{4}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "20120") (re.++ (re.union (re.++ (str.to_re "7") (re.union (re.union (re.++ (str.to_re "1") (re.range "5" "9")) (re.++ (str.to_re "2") (re.range "0" "9"))) (re.++ (str.to_re "3") (str.to_re "01")))) (re.++ (str.to_re "8") (re.union (re.++ (re.range "0" "1") (re.range "0" "9")) (str.to_re "20")))) ((_ re.loop 4 4) (re.range "0" "9"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)