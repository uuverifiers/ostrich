;test regex (([ABCDEFGHJKLMNPQRSTVXYZ0123456789]{8})-?){4}
(declare-const X String)
(assert (str.in_re X ((_ re.loop 4 4) (re.++ ((_ re.loop 8 8) (re.union (str.to_re "A") (re.union (str.to_re "B") (re.union (str.to_re "C") (re.union (str.to_re "D") (re.union (str.to_re "E") (re.union (str.to_re "F") (re.union (str.to_re "G") (re.union (str.to_re "H") (re.union (str.to_re "J") (re.union (str.to_re "K") (re.union (str.to_re "L") (re.union (str.to_re "M") (re.union (str.to_re "N") (re.union (str.to_re "P") (re.union (str.to_re "Q") (re.union (str.to_re "R") (re.union (str.to_re "S") (re.union (str.to_re "T") (re.union (str.to_re "V") (re.union (str.to_re "X") (re.union (str.to_re "Y") (re.union (str.to_re "Z") (str.to_re "0123456789")))))))))))))))))))))))) (re.opt (str.to_re "-"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)