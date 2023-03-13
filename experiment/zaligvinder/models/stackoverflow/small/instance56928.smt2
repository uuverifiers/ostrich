;test regex ^(?:4[0-9]{12}(?:[0-9]{3})?|(?:5[1-5][0-9]{2}|222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720)[0-9]{12}|3[47][0-9]{13})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union (re.++ (str.to_re "4") (re.++ ((_ re.loop 12 12) (re.range "0" "9")) (re.opt ((_ re.loop 3 3) (re.range "0" "9"))))) (re.++ (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "5") (re.++ (re.range "1" "5") ((_ re.loop 2 2) (re.range "0" "9")))) (re.++ (str.to_re "222") (re.range "1" "9"))) (re.++ (str.to_re "22") (re.++ (re.range "3" "9") (re.range "0" "9")))) (re.++ (str.to_re "2") (re.++ (re.range "3" "6") ((_ re.loop 2 2) (re.range "0" "9"))))) (re.++ (str.to_re "27") (re.++ (str.to_re "01") (re.range "0" "9")))) (str.to_re "2720")) ((_ re.loop 12 12) (re.range "0" "9")))) (re.++ (str.to_re "3") (re.++ (str.to_re "47") ((_ re.loop 13 13) (re.range "0" "9")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)