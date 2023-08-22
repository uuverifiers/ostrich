;test regex ^dejitter=(\d{1,10})(CDB=(\d{1,10})BTM=(0|1|2))?(TD=(\d{1,10}))?(BFR=(0|1))?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "d") (re.++ (str.to_re "e") (re.++ (str.to_re "j") (re.++ (str.to_re "i") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "=") (re.++ ((_ re.loop 1 10) (re.range "0" "9")) (re.++ (re.opt (re.++ (str.to_re "C") (re.++ (str.to_re "D") (re.++ (str.to_re "B") (re.++ (str.to_re "=") (re.++ ((_ re.loop 1 10) (re.range "0" "9")) (re.++ (str.to_re "B") (re.++ (str.to_re "T") (re.++ (str.to_re "M") (re.++ (str.to_re "=") (re.union (re.union (str.to_re "0") (str.to_re "1")) (str.to_re "2")))))))))))) (re.++ (re.opt (re.++ (str.to_re "T") (re.++ (str.to_re "D") (re.++ (str.to_re "=") ((_ re.loop 1 10) (re.range "0" "9")))))) (re.opt (re.++ (str.to_re "B") (re.++ (str.to_re "F") (re.++ (str.to_re "R") (re.++ (str.to_re "=") (re.union (str.to_re "0") (str.to_re "1")))))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)