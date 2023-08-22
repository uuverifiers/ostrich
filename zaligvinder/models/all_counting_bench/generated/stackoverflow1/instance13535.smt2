;test regex (10)(\.([2]([0-5][0-5]|[01234][6-9])|[1][0-9][0-9]|[1-9][0-9]|[0-9])){3}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "10") ((_ re.loop 3 3) (re.++ (str.to_re ".") (re.union (re.union (re.union (re.++ (str.to_re "2") (re.union (re.++ (re.range "0" "5") (re.range "0" "5")) (re.++ (str.to_re "01234") (re.range "6" "9")))) (re.++ (str.to_re "1") (re.++ (re.range "0" "9") (re.range "0" "9")))) (re.++ (re.range "1" "9") (re.range "0" "9"))) (re.range "0" "9")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)