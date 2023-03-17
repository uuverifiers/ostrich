;test regex ((?:1){10}|(?:2){10}|(?:3){10}|(?:4){10}|(?:5){10}|(?:6){10}|(?:7){10}|(?:8){10}|(?:9){10}|(?:0){10})
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union ((_ re.loop 10 10) (str.to_re "1")) ((_ re.loop 10 10) (str.to_re "2"))) ((_ re.loop 10 10) (str.to_re "3"))) ((_ re.loop 10 10) (str.to_re "4"))) ((_ re.loop 10 10) (str.to_re "5"))) ((_ re.loop 10 10) (str.to_re "6"))) ((_ re.loop 10 10) (str.to_re "7"))) ((_ re.loop 10 10) (str.to_re "8"))) ((_ re.loop 10 10) (str.to_re "9"))) ((_ re.loop 10 10) (str.to_re "0")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)