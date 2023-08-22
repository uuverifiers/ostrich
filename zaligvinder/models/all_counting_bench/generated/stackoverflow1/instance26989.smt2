;test regex "^[0-9](03|07|AA|[A-Z])[A-Z]{2}$"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "") (re.++ (re.range "0" "9") (re.++ (re.union (re.union (re.union (str.to_re "03") (str.to_re "07")) (re.++ (str.to_re "A") (str.to_re "A"))) (re.range "A" "Z")) ((_ re.loop 2 2) (re.range "A" "Z")))))) (re.++ (str.to_re "") (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)