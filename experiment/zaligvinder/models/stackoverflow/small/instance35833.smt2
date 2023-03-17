;test regex 3AE[a-zA-Z]{9}/{4}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "3") (re.++ (str.to_re "A") (re.++ (str.to_re "E") (re.++ ((_ re.loop 9 9) (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 4 4) (str.to_re "/"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)