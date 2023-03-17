;test regex (AT|BE|FR|IT)[0-9]{10}
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.union (re.union (re.++ (str.to_re "A") (str.to_re "T")) (re.++ (str.to_re "B") (str.to_re "E"))) (re.++ (str.to_re "F") (str.to_re "R"))) (re.++ (str.to_re "I") (str.to_re "T"))) ((_ re.loop 10 10) (re.range "0" "9")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)