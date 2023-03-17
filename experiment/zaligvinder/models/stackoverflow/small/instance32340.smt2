;test regex (CC|NP){1,9}
(declare-const X String)
(assert (str.in_re X ((_ re.loop 1 9) (re.union (re.++ (str.to_re "C") (str.to_re "C")) (re.++ (str.to_re "N") (str.to_re "P"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)