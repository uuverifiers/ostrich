;test regex ^([a-z\d][a-z\d-]{0,61}[a-z\d])\.tumblr\.com/
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.++ (re.union (re.range "a" "z") (re.range "0" "9")) (re.++ ((_ re.loop 0 61) (re.union (re.range "a" "z") (re.union (re.range "0" "9") (str.to_re "-")))) (re.union (re.range "a" "z") (re.range "0" "9")))) (re.++ (str.to_re ".") (re.++ (str.to_re "t") (re.++ (str.to_re "u") (re.++ (str.to_re "m") (re.++ (str.to_re "b") (re.++ (str.to_re "l") (re.++ (str.to_re "r") (re.++ (str.to_re ".") (re.++ (str.to_re "c") (re.++ (str.to_re "o") (re.++ (str.to_re "m") (str.to_re "/"))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)