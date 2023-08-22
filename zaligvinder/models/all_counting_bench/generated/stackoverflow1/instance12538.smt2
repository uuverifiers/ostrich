;test regex "ffffffff".matches("([a-z])\\1{3,}") = true
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "f") (re.++ (str.to_re "f") (re.++ (str.to_re "f") (re.++ (str.to_re "f") (re.++ (str.to_re "f") (re.++ (str.to_re "f") (re.++ (str.to_re "f") (re.++ (str.to_re "f") (re.++ (str.to_re "\u{22}") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "c") (re.++ (str.to_re "h") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (re.++ (re.++ (str.to_re "\u{22}") (re.++ (re.range "a" "z") (re.++ (str.to_re "\\") (re.++ (re.++ (re.* (str.to_re "1")) ((_ re.loop 3 3) (str.to_re "1"))) (str.to_re "\u{22}"))))) (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re " ") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re "u") (str.to_re "e"))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)