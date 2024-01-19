;test regex [a-zA-Z]{1}\.[a-zA-Z]+[0-9]{5}@([_a-z0-9\-])\.[a-zA-Z]
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ (str.to_re ".") (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (re.++ (str.to_re "@") (re.++ (re.union (str.to_re "_") (re.union (re.range "a" "z") (re.union (re.range "0" "9") (str.to_re "-")))) (re.++ (str.to_re ".") (re.union (re.range "a" "z") (re.range "A" "Z")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)