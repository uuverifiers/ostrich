;test regex 234(?:705|805|807|815)\d{7}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "234") (re.++ (re.union (re.union (re.union (str.to_re "705") (str.to_re "805")) (str.to_re "807")) (str.to_re "815")) ((_ re.loop 7 7) (re.range "0" "9"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)