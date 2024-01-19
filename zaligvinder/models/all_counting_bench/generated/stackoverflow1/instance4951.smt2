;test regex (1){11,}|(2){11,}|(3){11,}|(4){11,}|(5){11,}|(6){11,}|(7){11,}|(8){11,}|(9){11,}|(0){11,}
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.++ (re.* (str.to_re "1")) ((_ re.loop 11 11) (str.to_re "1"))) (re.++ (re.* (str.to_re "2")) ((_ re.loop 11 11) (str.to_re "2")))) (re.++ (re.* (str.to_re "3")) ((_ re.loop 11 11) (str.to_re "3")))) (re.++ (re.* (str.to_re "4")) ((_ re.loop 11 11) (str.to_re "4")))) (re.++ (re.* (str.to_re "5")) ((_ re.loop 11 11) (str.to_re "5")))) (re.++ (re.* (str.to_re "6")) ((_ re.loop 11 11) (str.to_re "6")))) (re.++ (re.* (str.to_re "7")) ((_ re.loop 11 11) (str.to_re "7")))) (re.++ (re.* (str.to_re "8")) ((_ re.loop 11 11) (str.to_re "8")))) (re.++ (re.* (str.to_re "9")) ((_ re.loop 11 11) (str.to_re "9")))) (re.++ (re.* (str.to_re "0")) ((_ re.loop 11 11) (str.to_re "0"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)