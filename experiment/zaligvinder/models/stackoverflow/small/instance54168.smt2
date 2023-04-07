;test regex I ([a-zA-Z]|\d){2,13}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "I") (re.++ (str.to_re " ") ((_ re.loop 2 13) (re.union (re.union (re.range "a" "z") (re.range "A" "Z")) (re.range "0" "9")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)