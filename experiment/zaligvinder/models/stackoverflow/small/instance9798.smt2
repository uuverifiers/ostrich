;test regex (0060|\+60|0)[0-9]{10}
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.union (str.to_re "0060") (re.++ (str.to_re "+") (str.to_re "60"))) (str.to_re "0")) ((_ re.loop 10 10) (re.range "0" "9")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)