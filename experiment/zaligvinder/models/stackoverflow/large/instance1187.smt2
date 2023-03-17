;test regex "fu:([^a-z].*|[^"]{51,}|[a-z]([^"]*?[A-Z][^"]*?)+|[a-z ]{0,49}[ ])"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "f") (re.++ (str.to_re "u") (re.++ (str.to_re ":") (re.++ (re.union (re.union (re.union (re.++ (re.diff re.allchar (re.range "a" "z")) (re.* (re.diff re.allchar (str.to_re "\n")))) (re.++ (re.* (re.diff re.allchar (str.to_re "\u{22}"))) ((_ re.loop 51 51) (re.diff re.allchar (str.to_re "\u{22}"))))) (re.++ (re.range "a" "z") (re.+ (re.++ (re.* (re.diff re.allchar (str.to_re "\u{22}"))) (re.++ (re.range "A" "Z") (re.* (re.diff re.allchar (str.to_re "\u{22}")))))))) (re.++ ((_ re.loop 0 49) (re.union (re.range "a" "z") (str.to_re " "))) (str.to_re " "))) (str.to_re "\u{22}"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)