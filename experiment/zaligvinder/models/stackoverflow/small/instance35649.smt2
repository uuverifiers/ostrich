;test regex ^(1{5}|2{5}|3{5}|4{5}|5{5}|6{5}|7{5}|8{5}|9{5}){2}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") ((_ re.loop 2 2) (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union ((_ re.loop 5 5) (str.to_re "1")) ((_ re.loop 5 5) (str.to_re "2"))) ((_ re.loop 5 5) (str.to_re "3"))) ((_ re.loop 5 5) (str.to_re "4"))) ((_ re.loop 5 5) (str.to_re "5"))) ((_ re.loop 5 5) (str.to_re "6"))) ((_ re.loop 5 5) (str.to_re "7"))) ((_ re.loop 5 5) (str.to_re "8"))) ((_ re.loop 5 5) (str.to_re "9"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)