;test regex ^ *D *E( *[A-Za-z0-9]){20} *$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.* (str.to_re " ")) (re.++ (str.to_re "D") (re.++ (re.* (str.to_re " ")) (re.++ (str.to_re "E") (re.++ ((_ re.loop 20 20) (re.++ (re.* (str.to_re " ")) (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9"))))) (re.* (str.to_re " ")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)