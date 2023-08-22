;test regex 999[0-9]{2}([0-8][0-9]|91|90)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "999") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.union (re.union (re.++ (re.range "0" "8") (re.range "0" "9")) (str.to_re "91")) (str.to_re "90"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)