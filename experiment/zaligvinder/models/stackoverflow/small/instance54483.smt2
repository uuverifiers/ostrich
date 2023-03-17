;test regex ([0-9]{2}-[a-zA-Z]{5,}[0-9]{5,}\.txt){1,}
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "-") (re.++ (re.++ (re.* (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 5 5) (re.union (re.range "a" "z") (re.range "A" "Z")))) (re.++ (re.++ (re.* (re.range "0" "9")) ((_ re.loop 5 5) (re.range "0" "9"))) (re.++ (str.to_re ".") (re.++ (str.to_re "t") (re.++ (str.to_re "x") (str.to_re "t"))))))))) ((_ re.loop 1 1) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "-") (re.++ (re.++ (re.* (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 5 5) (re.union (re.range "a" "z") (re.range "A" "Z")))) (re.++ (re.++ (re.* (re.range "0" "9")) ((_ re.loop 5 5) (re.range "0" "9"))) (re.++ (str.to_re ".") (re.++ (str.to_re "t") (re.++ (str.to_re "x") (str.to_re "t"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)