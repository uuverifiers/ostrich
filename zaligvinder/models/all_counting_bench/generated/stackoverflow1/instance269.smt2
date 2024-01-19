;test regex 1{3}21{3}|2{3}[13]2{3}|3{3}[24]3{3}|4{3}[35]4{3}|5{3}[46]5{3}|6{3}[57]6{3}|7{3}[68]7{3}|8{3}[79]8{3}|9{3}89{3}
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.++ ((_ re.loop 3 3) (str.to_re "1")) ((_ re.loop 3 3) (str.to_re "21"))) (re.++ ((_ re.loop 3 3) (str.to_re "2")) (re.++ (str.to_re "13") ((_ re.loop 3 3) (str.to_re "2"))))) (re.++ ((_ re.loop 3 3) (str.to_re "3")) (re.++ (str.to_re "24") ((_ re.loop 3 3) (str.to_re "3"))))) (re.++ ((_ re.loop 3 3) (str.to_re "4")) (re.++ (str.to_re "35") ((_ re.loop 3 3) (str.to_re "4"))))) (re.++ ((_ re.loop 3 3) (str.to_re "5")) (re.++ (str.to_re "46") ((_ re.loop 3 3) (str.to_re "5"))))) (re.++ ((_ re.loop 3 3) (str.to_re "6")) (re.++ (str.to_re "57") ((_ re.loop 3 3) (str.to_re "6"))))) (re.++ ((_ re.loop 3 3) (str.to_re "7")) (re.++ (str.to_re "68") ((_ re.loop 3 3) (str.to_re "7"))))) (re.++ ((_ re.loop 3 3) (str.to_re "8")) (re.++ (str.to_re "79") ((_ re.loop 3 3) (str.to_re "8"))))) (re.++ ((_ re.loop 3 3) (str.to_re "9")) ((_ re.loop 3 3) (str.to_re "89"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)