;test regex LG[a-zA-Z]{10}[0-9]{6}[0-9]{5}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "L") (re.++ (str.to_re "G") (re.++ ((_ re.loop 10 10) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ ((_ re.loop 6 6) (re.range "0" "9")) ((_ re.loop 5 5) (re.range "0" "9"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)