;test regex [0-9]{7}[a-z]+
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 7 7) (re.range "0" "9")) (re.+ (re.range "a" "z")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)