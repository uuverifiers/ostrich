;test regex ^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+(com|org|info|biz|us)/?([^/]*)/?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.+ (re.++ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9"))) (re.++ (re.opt (re.++ ((_ re.loop 0 61) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "-"))))) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9"))))) (str.to_re ".")))) (re.++ (re.union (re.union (re.union (re.union (re.++ (str.to_re "c") (re.++ (str.to_re "o") (str.to_re "m"))) (re.++ (str.to_re "o") (re.++ (str.to_re "r") (str.to_re "g")))) (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "f") (str.to_re "o"))))) (re.++ (str.to_re "b") (re.++ (str.to_re "i") (str.to_re "z")))) (re.++ (str.to_re "u") (str.to_re "s"))) (re.++ (re.opt (str.to_re "/")) (re.++ (re.* (re.diff re.allchar (str.to_re "/"))) (re.opt (str.to_re "/"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 200 (str.len X)))
(check-sat)
(get-model)