;test regex \d{4,5}[a-zA-Z]
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 4 5) (re.range "0" "9")) (re.union (re.range "a" "z") (re.range "A" "Z")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)