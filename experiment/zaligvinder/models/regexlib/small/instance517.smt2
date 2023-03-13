;test regex ^[0-9a-zA-Z]+([0-9a-zA-Z]*[-._+])*[0-9a-zA-Z]+@[0-9a-zA-Z]+([-.][0-9a-zA-Z]+)*([0-9a-zA-Z]*[.])[a-zA-Z]{2,6}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.+ (re.union (re.range "0" "9") (re.union (re.range "a" "z") (re.range "A" "Z")))) (re.++ (re.* (re.++ (re.* (re.union (re.range "0" "9") (re.union (re.range "a" "z") (re.range "A" "Z")))) (re.union (str.to_re "-") (re.union (str.to_re ".") (re.union (str.to_re "_") (str.to_re "+")))))) (re.++ (re.+ (re.union (re.range "0" "9") (re.union (re.range "a" "z") (re.range "A" "Z")))) (re.++ (str.to_re "@") (re.++ (re.+ (re.union (re.range "0" "9") (re.union (re.range "a" "z") (re.range "A" "Z")))) (re.++ (re.* (re.++ (re.union (str.to_re "-") (str.to_re ".")) (re.+ (re.union (re.range "0" "9") (re.union (re.range "a" "z") (re.range "A" "Z")))))) (re.++ (re.++ (re.* (re.union (re.range "0" "9") (re.union (re.range "a" "z") (re.range "A" "Z")))) (str.to_re ".")) ((_ re.loop 2 6) (re.union (re.range "a" "z") (re.range "A" "Z"))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)