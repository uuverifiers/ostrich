;test regex 0x[A-F0-9]{2}\g
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "0") (re.++ (str.to_re "x") (re.++ ((_ re.loop 2 2) (re.union (re.range "A" "F") (re.range "0" "9"))) (str.to_re "g"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)