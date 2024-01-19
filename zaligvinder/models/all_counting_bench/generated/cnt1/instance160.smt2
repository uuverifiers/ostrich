;test regex ^&(?:#x[a-f0-9]{1,8}|#[0-9]{1,8}|[a-z][a-z0-9]{1,31})
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (str.to_re "&") (re.union (re.union (re.++ (str.to_re "#") (re.++ (str.to_re "x") ((_ re.loop 1 8) (re.union (re.range "a" "f") (re.range "0" "9"))))) (re.++ (str.to_re "#") ((_ re.loop 1 8) (re.range "0" "9")))) (re.++ (re.range "a" "z") ((_ re.loop 1 31) (re.union (re.range "a" "z") (re.range "0" "9")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)