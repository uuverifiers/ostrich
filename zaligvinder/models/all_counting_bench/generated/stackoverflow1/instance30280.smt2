;test regex 0{6}|10{5}|010{4}|001000|000100|0{4}10|0{5}1
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.union (re.union (re.union ((_ re.loop 6 6) (str.to_re "0")) ((_ re.loop 5 5) (str.to_re "10"))) ((_ re.loop 4 4) (str.to_re "010"))) (str.to_re "001000")) (str.to_re "000100")) (re.++ ((_ re.loop 4 4) (str.to_re "0")) (str.to_re "10"))) (re.++ ((_ re.loop 5 5) (str.to_re "0")) (str.to_re "1")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)