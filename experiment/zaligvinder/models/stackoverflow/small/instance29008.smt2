;test regex ^[A-Z][a-z]{3,30}(\\s[A-Z](\\.|[a-z]{2,30})?)*$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.range "A" "Z") (re.++ ((_ re.loop 3 30) (re.range "a" "z")) (re.* (re.++ (str.to_re "\\") (re.++ (str.to_re "s") (re.++ (re.range "A" "Z") (re.opt (re.union (re.++ (str.to_re "\\") (re.diff re.allchar (str.to_re "\n"))) ((_ re.loop 2 30) (re.range "a" "z"))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)