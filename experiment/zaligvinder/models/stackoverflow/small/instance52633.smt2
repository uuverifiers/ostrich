;test regex ^(\+393|3|\+39|0)([0-9]{9})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.union (re.union (re.++ (str.to_re "+") (str.to_re "393")) (str.to_re "3")) (re.++ (str.to_re "+") (str.to_re "39"))) (str.to_re "0")) ((_ re.loop 9 9) (re.range "0" "9")))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)