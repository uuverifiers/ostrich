;test regex (AB|DE|GH)[a-zA-Z0-9]{15}
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.union (re.++ (str.to_re "A") (str.to_re "B")) (re.++ (str.to_re "D") (str.to_re "E"))) (re.++ (str.to_re "G") (str.to_re "H"))) ((_ re.loop 15 15) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)