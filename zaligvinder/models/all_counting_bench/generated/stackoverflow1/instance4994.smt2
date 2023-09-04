;test regex ^([01]?[0-9]{1,2}|2([0-4][0-9]|50))$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.++ (re.opt (str.to_re "01")) ((_ re.loop 1 2) (re.range "0" "9"))) (re.++ (str.to_re "2") (re.union (re.++ (re.range "0" "4") (re.range "0" "9")) (str.to_re "50"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)