;test regex (([a-zA-Z ]+, [a-zA-z]+) ((\d{5})|([a-zA-Z]\d[a-zA-Z] ?\d[a-zA-Z]\d))?|((\d{5})|([a-zA-Z]\d[a-zA-Z] ?\d[a-zA-Z]\d)))
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (re.++ (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (str.to_re " ")))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.+ (re.union (re.range "a" "z") (re.range "A" "z")))))) (re.++ (str.to_re " ") (re.opt (re.union ((_ re.loop 5 5) (re.range "0" "9")) (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (re.++ (re.range "0" "9") (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (re.++ (re.opt (str.to_re " ")) (re.++ (re.range "0" "9") (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (re.range "0" "9"))))))))))) (re.union ((_ re.loop 5 5) (re.range "0" "9")) (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (re.++ (re.range "0" "9") (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (re.++ (re.opt (str.to_re " ")) (re.++ (re.range "0" "9") (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (re.range "0" "9")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)