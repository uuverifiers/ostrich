;test regex 0[2349]-[1-9]\d{6}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "0") (re.++ (str.to_re "2349") (re.++ (str.to_re "-") (re.++ (re.range "1" "9") ((_ re.loop 6 6) (re.range "0" "9"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)