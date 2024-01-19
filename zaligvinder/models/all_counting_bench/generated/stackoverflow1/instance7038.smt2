;test regex ^((4[38][0-9]{13}))|((6[0-9]{12}([0-9]{3})?))|((8[5-8][0-9]{14}))$
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (str.to_re "") (re.++ (str.to_re "4") (re.++ (str.to_re "38") ((_ re.loop 13 13) (re.range "0" "9"))))) (re.++ (str.to_re "6") (re.++ ((_ re.loop 12 12) (re.range "0" "9")) (re.opt ((_ re.loop 3 3) (re.range "0" "9")))))) (re.++ (re.++ (str.to_re "8") (re.++ (re.range "5" "8") ((_ re.loop 14 14) (re.range "0" "9")))) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)