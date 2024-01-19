;test regex (v[ao]n|[A-Z][a-z]{1,2}[A-Z])?
(declare-const X String)
(assert (str.in_re X (re.opt (re.union (re.++ (str.to_re "v") (re.++ (re.union (str.to_re "a") (str.to_re "o")) (str.to_re "n"))) (re.++ (re.range "A" "Z") (re.++ ((_ re.loop 1 2) (re.range "a" "z")) (re.range "A" "Z")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)