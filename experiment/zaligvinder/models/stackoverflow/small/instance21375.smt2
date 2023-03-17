;test regex [a-z]{0,3}f[a-z]{2}e[a-z]{0,5}
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 0 3) (re.range "a" "z")) (re.++ (str.to_re "f") (re.++ ((_ re.loop 2 2) (re.range "a" "z")) (re.++ (str.to_re "e") ((_ re.loop 0 5) (re.range "a" "z"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)