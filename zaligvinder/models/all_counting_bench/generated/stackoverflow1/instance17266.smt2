;test regex ^(?:\+971|0(0971)?)(?:[234679]|5[01256])[0-9]{7}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.++ (str.to_re "+") (str.to_re "971")) (re.++ (str.to_re "0") (re.opt (str.to_re "0971")))) (re.++ (re.union (str.to_re "234679") (re.++ (str.to_re "5") (str.to_re "01256"))) ((_ re.loop 7 7) (re.range "0" "9"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)