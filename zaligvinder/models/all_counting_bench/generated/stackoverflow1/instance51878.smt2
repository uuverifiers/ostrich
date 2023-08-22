;test regex <[A-Z][A-Z]{2,}>^t<[a-z][a-z]{2,}>
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "<") (re.++ (re.range "A" "Z") (re.++ (re.++ (re.* (re.range "A" "Z")) ((_ re.loop 2 2) (re.range "A" "Z"))) (str.to_re ">")))) (re.++ (str.to_re "") (re.++ (str.to_re "t") (re.++ (str.to_re "<") (re.++ (re.range "a" "z") (re.++ (re.++ (re.* (re.range "a" "z")) ((_ re.loop 2 2) (re.range "a" "z"))) (str.to_re ">")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)