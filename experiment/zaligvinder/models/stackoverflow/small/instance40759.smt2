;test regex [0-9]{1,}[a-zA-Z]{1,}[a-zA-Z0-9]{0,}
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.* (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ (re.++ (re.* (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.range "A" "Z")))) (re.++ (re.* (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9")))) ((_ re.loop 0 0) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)