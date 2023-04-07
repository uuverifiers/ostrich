;test regex (O|T)\d{9}T[D\d]{25}O[\d ]{5}
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (str.to_re "O") (str.to_re "T")) (re.++ ((_ re.loop 9 9) (re.range "0" "9")) (re.++ (str.to_re "T") (re.++ ((_ re.loop 25 25) (re.union (str.to_re "D") (re.range "0" "9"))) (re.++ (str.to_re "O") ((_ re.loop 5 5) (re.union (re.range "0" "9") (str.to_re " "))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)