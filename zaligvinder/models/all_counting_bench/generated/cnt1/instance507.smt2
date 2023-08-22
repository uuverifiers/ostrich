;test regex ObjectID\(([0-9a-f]{24})\)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "O") (re.++ (str.to_re "b") (re.++ (str.to_re "j") (re.++ (str.to_re "e") (re.++ (str.to_re "c") (re.++ (str.to_re "t") (re.++ (str.to_re "I") (re.++ (str.to_re "D") (re.++ (str.to_re "(") (re.++ ((_ re.loop 24 24) (re.union (re.range "0" "9") (re.range "a" "f"))) (str.to_re ")")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)