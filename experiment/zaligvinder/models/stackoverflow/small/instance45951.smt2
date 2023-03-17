;test regex "[a-zA-Z][\\s-'a-zA-Z]{0,14}"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (re.++ ((_ re.loop 0 14) (re.union (str.to_re "\\") (re.union (re.range "s" "\u{27}") (re.union (re.range "a" "z") (re.range "A" "Z"))))) (str.to_re "\u{22}"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)