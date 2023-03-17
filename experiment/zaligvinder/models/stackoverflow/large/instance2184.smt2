;test regex ^[A-Z][a-z][0-9]|[A-Z][0-9][a-z]|[a-z][A-Z][0-9]|[a-z][0-9][A-Z]|[0-9][A-Z]|[A-Z]|[a-z]{100}$
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "") (re.++ (re.range "A" "Z") (re.++ (re.range "a" "z") (re.range "0" "9")))) (re.++ (re.range "A" "Z") (re.++ (re.range "0" "9") (re.range "a" "z")))) (re.++ (re.range "a" "z") (re.++ (re.range "A" "Z") (re.range "0" "9")))) (re.++ (re.range "a" "z") (re.++ (re.range "0" "9") (re.range "A" "Z")))) (re.++ (re.range "0" "9") (re.range "A" "Z"))) (re.range "A" "Z")) (re.++ ((_ re.loop 100 100) (re.range "a" "z")) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)