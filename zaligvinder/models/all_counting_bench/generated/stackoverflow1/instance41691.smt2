;test regex (A{2}|B{2}|C{2})
(declare-const X String)
(assert (str.in_re X (re.union (re.union ((_ re.loop 2 2) (str.to_re "A")) ((_ re.loop 2 2) (str.to_re "B"))) ((_ re.loop 2 2) (str.to_re "C")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)