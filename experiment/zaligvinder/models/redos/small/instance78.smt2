;test regex ^(job|analysis)-[0-9A-Za-z]{24}:[a-zA-Z_][0-9a-zA-Z_]*$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.++ (str.to_re "j") (re.++ (str.to_re "o") (str.to_re "b"))) (re.++ (str.to_re "a") (re.++ (str.to_re "n") (re.++ (str.to_re "a") (re.++ (str.to_re "l") (re.++ (str.to_re "y") (re.++ (str.to_re "s") (re.++ (str.to_re "i") (str.to_re "s"))))))))) (re.++ (str.to_re "-") (re.++ ((_ re.loop 24 24) (re.union (re.range "0" "9") (re.union (re.range "A" "Z") (re.range "a" "z")))) (re.++ (str.to_re ":") (re.++ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (str.to_re "_"))) (re.* (re.union (re.range "0" "9") (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (str.to_re "_"))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)