;test regex (?:2[5-9]|[3-9]\d|[1-9]\d{2}|1000)
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.++ (str.to_re "2") (re.range "5" "9")) (re.++ (re.range "3" "9") (re.range "0" "9"))) (re.++ (re.range "1" "9") ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "1000"))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)