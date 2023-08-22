;test regex \\x[0-9a-f]{2}|\\u\d{4}
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "\\") (re.++ (str.to_re "x") ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "a" "f"))))) (re.++ (str.to_re "\\") (re.++ (str.to_re "u") ((_ re.loop 4 4) (re.range "0" "9")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)