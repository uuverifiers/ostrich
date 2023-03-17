;test regex ^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|6011[0-9]{12}|3(?:0[0-5]|[68][0-9])[0-9]{11}|3[47][0-9]{13})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union (re.union (re.union (re.++ (str.to_re "4") (re.++ ((_ re.loop 12 12) (re.range "0" "9")) (re.opt ((_ re.loop 3 3) (re.range "0" "9"))))) (re.++ (str.to_re "5") (re.++ (re.range "1" "5") ((_ re.loop 14 14) (re.range "0" "9"))))) (re.++ (str.to_re "6011") ((_ re.loop 12 12) (re.range "0" "9")))) (re.++ (str.to_re "3") (re.++ (re.union (re.++ (str.to_re "0") (re.range "0" "5")) (re.++ (str.to_re "68") (re.range "0" "9"))) ((_ re.loop 11 11) (re.range "0" "9"))))) (re.++ (str.to_re "3") (re.++ (str.to_re "47") ((_ re.loop 13 13) (re.range "0" "9")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)