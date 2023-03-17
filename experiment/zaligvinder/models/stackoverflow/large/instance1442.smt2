;test regex [A-Za-z]{2,64}
(declare-const X String)
(assert (str.in_re X ((_ re.loop 2 64) (re.union (re.range "A" "Z") (re.range "a" "z")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)