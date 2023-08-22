;test regex (r'(\.|\/)(([A-Za-z\d]+|[A-Za-z\d][-])+[A-Za-z\d]+){1,63}\.([A-Za-z]{2,3}\.[A-Za-z]{2}|[A-Za-z]{2,6})')
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "r") (re.++ (str.to_re "\u{27}") (re.++ (re.union (str.to_re ".") (str.to_re "/")) (re.++ ((_ re.loop 1 63) (re.++ (re.+ (re.union (re.+ (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9")))) (re.++ (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "-")))) (re.+ (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9")))))) (re.++ (str.to_re ".") (re.++ (re.union (re.++ ((_ re.loop 2 3) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "a" "z"))))) ((_ re.loop 2 6) (re.union (re.range "A" "Z") (re.range "a" "z")))) (str.to_re "\u{27}")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 200 (str.len X)))
(check-sat)
(get-model)