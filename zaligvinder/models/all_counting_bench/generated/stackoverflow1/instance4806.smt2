;test regex ([a-zA-Z]|[0-9]){0,8}
(declare-const X String)
(assert (str.in_re X ((_ re.loop 0 8) (re.union (re.union (re.range "a" "z") (re.range "A" "Z")) (re.range "0" "9")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)