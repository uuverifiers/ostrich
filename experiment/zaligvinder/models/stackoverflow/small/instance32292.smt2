;test regex %ul#sub-nav(\n.*$){8}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "%") (re.++ (str.to_re "u") (re.++ (str.to_re "l") (re.++ (str.to_re "#") (re.++ (str.to_re "s") (re.++ (str.to_re "u") (re.++ (str.to_re "b") (re.++ (str.to_re "-") (re.++ (str.to_re "n") (re.++ (str.to_re "a") (re.++ (str.to_re "v") ((_ re.loop 8 8) (re.++ (re.++ (str.to_re "\u{0a}") (re.* (re.diff re.allchar (str.to_re "\n")))) (str.to_re ""))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)