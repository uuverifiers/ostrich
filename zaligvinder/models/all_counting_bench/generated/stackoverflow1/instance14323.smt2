;test regex "fu:(?:[a-z][a-z ]{0,47}[a-z]|[a-z]?)"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "f") (re.++ (str.to_re "u") (re.++ (str.to_re ":") (re.++ (re.union (re.++ (re.range "a" "z") (re.++ ((_ re.loop 0 47) (re.union (re.range "a" "z") (str.to_re " "))) (re.range "a" "z"))) (re.opt (re.range "a" "z"))) (str.to_re "\u{22}"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)