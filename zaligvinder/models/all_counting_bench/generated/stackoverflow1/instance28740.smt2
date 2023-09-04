;test regex ((?:[a-zA-Z0-9]*\/)*[a-zA-Z]*.[A-ZA-z]{3,4})
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.++ (re.* (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9")))) (str.to_re "/"))) (re.++ (re.* (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ (re.diff re.allchar (str.to_re "\n")) ((_ re.loop 3 4) (re.union (re.range "A" "Z") (re.range "A" "z"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)