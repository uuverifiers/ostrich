;test regex SUM(RLIKE '0{4}|1{4}|2{4}|3{4}|4{4}|5{4}|6{4}|7{4}|8{4}|9{4}')
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "S") (re.++ (str.to_re "U") (re.++ (str.to_re "M") (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "R") (re.++ (str.to_re "L") (re.++ (str.to_re "I") (re.++ (str.to_re "K") (re.++ (str.to_re "E") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{27}") ((_ re.loop 4 4) (str.to_re "0"))))))))) ((_ re.loop 4 4) (str.to_re "1"))) ((_ re.loop 4 4) (str.to_re "2"))) ((_ re.loop 4 4) (str.to_re "3"))) ((_ re.loop 4 4) (str.to_re "4"))) ((_ re.loop 4 4) (str.to_re "5"))) ((_ re.loop 4 4) (str.to_re "6"))) ((_ re.loop 4 4) (str.to_re "7"))) ((_ re.loop 4 4) (str.to_re "8"))) (re.++ ((_ re.loop 4 4) (str.to_re "9")) (str.to_re "\u{27}"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)