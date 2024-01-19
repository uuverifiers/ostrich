;test regex r'TEST\d{1,2}'
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "r") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "T") (re.++ (str.to_re "E") (re.++ (str.to_re "S") (re.++ (str.to_re "T") (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "\u{27}"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)