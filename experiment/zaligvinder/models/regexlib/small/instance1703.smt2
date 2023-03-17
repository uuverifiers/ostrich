;test regex (NL-?)?[0-9]{9}B[0-9]{2}
(declare-const X String)
(assert (str.in_re X (re.++ (re.opt (re.++ (str.to_re "N") (re.++ (str.to_re "L") (re.opt (str.to_re "-"))))) (re.++ ((_ re.loop 9 9) (re.range "0" "9")) (re.++ (str.to_re "B") ((_ re.loop 2 2) (re.range "0" "9")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)