;test regex ^[a-z A-Z]_?\_[a-z A-Z]*_\[[0-9]*\][a-z A-Z]*_[a-z A-Z 0-9]*_[a-z A-Z 0-9]{3}\.[a-z A-Z]*
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.union (re.range "a" "z") (re.union (str.to_re " ") (re.range "A" "Z"))) (re.++ (re.opt (str.to_re "_")) (re.++ (str.to_re "_") (re.++ (re.* (re.union (re.range "a" "z") (re.union (str.to_re " ") (re.range "A" "Z")))) (re.++ (str.to_re "_") (re.++ (str.to_re "[") (re.++ (re.* (re.range "0" "9")) (re.++ (str.to_re "]") (re.++ (re.* (re.union (re.range "a" "z") (re.union (str.to_re " ") (re.range "A" "Z")))) (re.++ (str.to_re "_") (re.++ (re.* (re.union (re.range "a" "z") (re.union (str.to_re " ") (re.union (re.range "A" "Z") (re.union (str.to_re " ") (re.range "0" "9")))))) (re.++ (str.to_re "_") (re.++ ((_ re.loop 3 3) (re.union (re.range "a" "z") (re.union (str.to_re " ") (re.union (re.range "A" "Z") (re.union (str.to_re " ") (re.range "0" "9")))))) (re.++ (str.to_re ".") (re.* (re.union (re.range "a" "z") (re.union (str.to_re " ") (re.range "A" "Z")))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)