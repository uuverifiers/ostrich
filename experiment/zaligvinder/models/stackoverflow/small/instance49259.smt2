;test regex [b-df-hj-np-tv-z]{3}
(declare-const X String)
(assert (str.in_re X ((_ re.loop 3 3) (re.union (re.range "b" "d") (re.union (re.range "f" "h") (re.union (re.range "j" "n") (re.union (re.range "p" "t") (re.range "v" "z"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)