;test regex ^\"([^\"\\]*|\\(["\\\/bfnrt]{1}|u[a-f0-9]{4}))*\"$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "\u{22}") (re.++ (re.* (re.union (re.* (re.inter (re.diff re.allchar (str.to_re "\u{22}")) (re.diff re.allchar (str.to_re "\\")))) (re.++ (str.to_re "\\") (re.union ((_ re.loop 1 1) (re.union (str.to_re "\u{22}") (re.union (str.to_re "\\") (re.union (str.to_re "/") (re.union (str.to_re "b") (re.union (str.to_re "f") (re.union (str.to_re "n") (re.union (str.to_re "r") (str.to_re "t"))))))))) (re.++ (str.to_re "u") ((_ re.loop 4 4) (re.union (re.range "a" "f") (re.range "0" "9")))))))) (str.to_re "\u{22}")))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)