;test regex ((PL|SK)-?)?[0-9]{10}
(declare-const X String)
(assert (str.in_re X (re.++ (re.opt (re.++ (re.union (re.++ (str.to_re "P") (str.to_re "L")) (re.++ (str.to_re "S") (str.to_re "K"))) (re.opt (str.to_re "-")))) ((_ re.loop 10 10) (re.range "0" "9")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)