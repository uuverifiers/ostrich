;test regex (PORT|CW|TW)[0-9]{8,}
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.union (re.++ (str.to_re "P") (re.++ (str.to_re "O") (re.++ (str.to_re "R") (str.to_re "T")))) (re.++ (str.to_re "C") (str.to_re "W"))) (re.++ (str.to_re "T") (str.to_re "W"))) (re.++ (re.* (re.range "0" "9")) ((_ re.loop 8 8) (re.range "0" "9"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)