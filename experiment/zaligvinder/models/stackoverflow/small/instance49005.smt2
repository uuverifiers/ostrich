;test regex [A-Za-su-z][A-Za-df-z]{0,1}[A-Za-rt-z]{0,1}[A-Za-su-z]{0,1}
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.range "A" "Z") (re.union (re.range "a" "s") (re.range "u" "z"))) (re.++ ((_ re.loop 0 1) (re.union (re.range "A" "Z") (re.union (re.range "a" "d") (re.range "f" "z")))) (re.++ ((_ re.loop 0 1) (re.union (re.range "A" "Z") (re.union (re.range "a" "r") (re.range "t" "z")))) ((_ re.loop 0 1) (re.union (re.range "A" "Z") (re.union (re.range "a" "s") (re.range "u" "z")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)