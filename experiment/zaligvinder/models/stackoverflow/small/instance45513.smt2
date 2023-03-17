;test regex A{12}|A{8}|A{4}
(declare-const X String)
(assert (str.in_re X (re.union (re.union ((_ re.loop 12 12) (str.to_re "A")) ((_ re.loop 8 8) (str.to_re "A"))) ((_ re.loop 4 4) (str.to_re "A")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)