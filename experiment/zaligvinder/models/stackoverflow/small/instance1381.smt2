;test regex ^(\+6[0236]\d{7,11})|(0\d{8,12})$
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "") (re.++ (str.to_re "+") (re.++ (str.to_re "6") (re.++ (str.to_re "0236") ((_ re.loop 7 11) (re.range "0" "9")))))) (re.++ (re.++ (str.to_re "0") ((_ re.loop 8 12) (re.range "0" "9"))) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)