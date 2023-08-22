;test regex ^ *while +\( *([a-zA-Z][a-zA-Z0-9_]*) *([=<>]{1,2}) *([a-zA-Z][a-zA-Z0-9_]*|[0-9]+) *\) *$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.* (str.to_re " ")) (re.++ (str.to_re "w") (re.++ (str.to_re "h") (re.++ (str.to_re "i") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (re.++ (re.+ (str.to_re " ")) (re.++ (str.to_re "(") (re.++ (re.* (str.to_re " ")) (re.++ (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (re.* (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))))) (re.++ (re.* (str.to_re " ")) (re.++ ((_ re.loop 1 2) (re.union (str.to_re "=") (re.union (str.to_re "<") (str.to_re ">")))) (re.++ (re.* (str.to_re " ")) (re.++ (re.union (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (re.* (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))))) (re.+ (re.range "0" "9"))) (re.++ (re.* (str.to_re " ")) (re.++ (str.to_re ")") (re.* (str.to_re " "))))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)