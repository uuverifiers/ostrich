;test regex wh{3,5}y
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "w") (re.++ ((_ re.loop 3 5) (str.to_re "h")) (str.to_re "y")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)