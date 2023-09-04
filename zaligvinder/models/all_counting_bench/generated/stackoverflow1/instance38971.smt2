;test regex 0[12378][0-9]{7,10}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "0") (re.++ (str.to_re "12378") ((_ re.loop 7 10) (re.range "0" "9"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)