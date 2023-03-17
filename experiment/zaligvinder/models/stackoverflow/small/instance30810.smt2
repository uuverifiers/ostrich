;test regex 9(0[012]|1[0346])[0-9]{2}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "9") (re.++ (re.union (re.++ (str.to_re "0") (str.to_re "012")) (re.++ (str.to_re "1") (str.to_re "0346"))) ((_ re.loop 2 2) (re.range "0" "9"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)