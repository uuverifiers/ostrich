;test regex (7[5-9][0-9]|8[0-9][0-9]|900)[A-Z]{7}
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.union (re.++ (str.to_re "7") (re.++ (re.range "5" "9") (re.range "0" "9"))) (re.++ (str.to_re "8") (re.++ (re.range "0" "9") (re.range "0" "9")))) (str.to_re "900")) ((_ re.loop 7 7) (re.range "A" "Z")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)