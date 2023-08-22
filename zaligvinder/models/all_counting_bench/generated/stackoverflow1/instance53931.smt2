;test regex "([A-Za-z]+ {0,1}\(.*?\))"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (re.++ (re.+ (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.++ ((_ re.loop 0 1) (str.to_re " ")) (re.++ (str.to_re "(") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (str.to_re ")"))))) (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)