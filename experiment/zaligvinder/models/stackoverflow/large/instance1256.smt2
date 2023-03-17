;test regex \u{1234}{2}
(declare-const X String)
(assert (str.in_re X ((_ re.loop 2 2) ((_ re.loop 1234 1234) (str.to_re "u")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)