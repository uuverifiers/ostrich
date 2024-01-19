;test regex ^([A-Za-z][A-Ha-hJ-Yj-y]?[0-9][A-Za-z0-9]? ?[0-9][A-Za-z]{2}|[Gg][Ii][Rr] ?0[Aa]{2})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.++ (re.union (re.range "A" "Z") (re.range "a" "z")) (re.++ (re.opt (re.union (re.range "A" "H") (re.union (re.range "a" "h") (re.union (re.range "J" "Y") (re.range "j" "y"))))) (re.++ (re.range "0" "9") (re.++ (re.opt (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9")))) (re.++ (re.opt (str.to_re " ")) (re.++ (re.range "0" "9") ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "a" "z"))))))))) (re.++ (re.union (str.to_re "G") (str.to_re "g")) (re.++ (re.union (str.to_re "I") (str.to_re "i")) (re.++ (re.union (str.to_re "R") (str.to_re "r")) (re.++ (re.opt (str.to_re " ")) (re.++ (str.to_re "0") ((_ re.loop 2 2) (re.union (str.to_re "A") (str.to_re "a")))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)