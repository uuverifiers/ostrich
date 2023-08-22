;test regex 0{3,}|1{3,}|2{3,}|3{3,}|4{3,}|5{3,}|6{3,}|7{3,}|8{3,}|9{3,}
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.++ (re.* (str.to_re "0")) ((_ re.loop 3 3) (str.to_re "0"))) (re.++ (re.* (str.to_re "1")) ((_ re.loop 3 3) (str.to_re "1")))) (re.++ (re.* (str.to_re "2")) ((_ re.loop 3 3) (str.to_re "2")))) (re.++ (re.* (str.to_re "3")) ((_ re.loop 3 3) (str.to_re "3")))) (re.++ (re.* (str.to_re "4")) ((_ re.loop 3 3) (str.to_re "4")))) (re.++ (re.* (str.to_re "5")) ((_ re.loop 3 3) (str.to_re "5")))) (re.++ (re.* (str.to_re "6")) ((_ re.loop 3 3) (str.to_re "6")))) (re.++ (re.* (str.to_re "7")) ((_ re.loop 3 3) (str.to_re "7")))) (re.++ (re.* (str.to_re "8")) ((_ re.loop 3 3) (str.to_re "8")))) (re.++ (re.* (str.to_re "9")) ((_ re.loop 3 3) (str.to_re "9"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)