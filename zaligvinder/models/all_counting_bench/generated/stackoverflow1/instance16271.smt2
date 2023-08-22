;test regex \d{0,4}[a-zA-Z]{0,2}\d{0,3}
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 0 4) (re.range "0" "9")) (re.++ ((_ re.loop 0 2) (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 0 3) (re.range "0" "9"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)