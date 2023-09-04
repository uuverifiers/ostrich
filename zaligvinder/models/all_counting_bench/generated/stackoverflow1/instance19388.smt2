;test regex [A-z][A-z0-9_\.]{24}
(declare-const X String)
(assert (str.in_re X (re.++ (re.range "A" "z") ((_ re.loop 24 24) (re.union (re.range "A" "z") (re.union (re.range "0" "9") (re.union (str.to_re "_") (str.to_re "."))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)