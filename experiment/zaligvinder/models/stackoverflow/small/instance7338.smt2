;test regex [mMrRsSdDlLtTcCoO]{2,4}
(declare-const X String)
(assert (str.in_re X ((_ re.loop 2 4) (re.union (str.to_re "m") (re.union (str.to_re "M") (re.union (str.to_re "r") (re.union (str.to_re "R") (re.union (str.to_re "s") (re.union (str.to_re "S") (re.union (str.to_re "d") (re.union (str.to_re "D") (re.union (str.to_re "l") (re.union (str.to_re "L") (re.union (str.to_re "t") (re.union (str.to_re "T") (re.union (str.to_re "c") (re.union (str.to_re "C") (re.union (str.to_re "o") (str.to_re "O")))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)