;test regex ^[a-z](\w+\.?\w*[a-z0-9]){5,17}@[a-z](([a-z0-9\-]{1,25}\.[a-z]{2,4})|([a-z0-9\-]{1,25}\.[a-z]{2,3}\.[a-z]{2,3}))$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.range "a" "z") (re.++ ((_ re.loop 5 17) (re.++ (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (re.++ (re.opt (str.to_re ".")) (re.++ (re.* (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (re.union (re.range "a" "z") (re.range "0" "9")))))) (re.++ (str.to_re "@") (re.++ (re.range "a" "z") (re.union (re.++ ((_ re.loop 1 25) (re.union (re.range "a" "z") (re.union (re.range "0" "9") (str.to_re "-")))) (re.++ (str.to_re ".") ((_ re.loop 2 4) (re.range "a" "z")))) (re.++ ((_ re.loop 1 25) (re.union (re.range "a" "z") (re.union (re.range "0" "9") (str.to_re "-")))) (re.++ (str.to_re ".") (re.++ ((_ re.loop 2 3) (re.range "a" "z")) (re.++ (str.to_re ".") ((_ re.loop 2 3) (re.range "a" "z")))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)