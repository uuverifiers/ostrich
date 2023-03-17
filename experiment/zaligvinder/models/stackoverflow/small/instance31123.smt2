;test regex (0|\+98)?(90|91|92|93|94|99)[0-9]{8}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.opt (re.union (str.to_re "0") (re.++ (str.to_re "+") (str.to_re "98")))) (re.++ (re.union (re.union (re.union (re.union (re.union (str.to_re "90") (str.to_re "91")) (str.to_re "92")) (str.to_re "93")) (str.to_re "94")) (str.to_re "99")) ((_ re.loop 8 8) (re.range "0" "9")))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)