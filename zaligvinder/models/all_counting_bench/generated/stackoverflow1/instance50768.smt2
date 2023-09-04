;test regex [AWMS]{2}
(declare-const X String)
(assert (str.in_re X ((_ re.loop 2 2) (re.union (str.to_re "A") (re.union (str.to_re "W") (re.union (str.to_re "M") (str.to_re "S")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)