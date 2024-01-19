;test regex ^((4(\d{12}|\d{15}))|(5\d{15})|(6011\d{12})|(3(4|7)\d{13}))$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union (re.union (re.++ (str.to_re "4") (re.union ((_ re.loop 12 12) (re.range "0" "9")) ((_ re.loop 15 15) (re.range "0" "9")))) (re.++ (str.to_re "5") ((_ re.loop 15 15) (re.range "0" "9")))) (re.++ (str.to_re "6011") ((_ re.loop 12 12) (re.range "0" "9")))) (re.++ (str.to_re "3") (re.++ (re.union (str.to_re "4") (str.to_re "7")) ((_ re.loop 13 13) (re.range "0" "9")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)