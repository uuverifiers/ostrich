;test regex [12a-j]{12}
(declare-const X String)
(assert (str.in_re X ((_ re.loop 12 12) (re.union (str.to_re "12") (re.range "a" "j")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)