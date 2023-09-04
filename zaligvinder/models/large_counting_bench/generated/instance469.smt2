;test regex [A-Fa-f0-9]{128}
(declare-const X String)
(assert (str.in_re X ((_ re.loop 128 128) (re.union (re.range "A" "F") (re.union (re.range "a" "f") (re.range "0" "9"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 200 (str.len X)))
(check-sat)
(get-model)