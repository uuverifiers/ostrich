;test regex 0{1,5}|0{1,4}1|0{1,4}2
(declare-const X String)
(assert (str.in_re X (re.union (re.union ((_ re.loop 1 5) (str.to_re "0")) (re.++ ((_ re.loop 1 4) (str.to_re "0")) (str.to_re "1"))) (re.++ ((_ re.loop 1 4) (str.to_re "0")) (str.to_re "2")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)