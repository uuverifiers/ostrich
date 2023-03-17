;test regex [A-Za-z\\s]*([A-Za-z]{3,})+[A-Za-z\\s]* (works in Java)
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.union (str.to_re "\\") (str.to_re "s"))))) (re.++ (re.+ (re.++ (re.* (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 3 3) (re.union (re.range "A" "Z") (re.range "a" "z"))))) (re.++ (re.* (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.union (str.to_re "\\") (str.to_re "s"))))) (re.++ (str.to_re " ") (re.++ (str.to_re "w") (re.++ (str.to_re "o") (re.++ (str.to_re "r") (re.++ (str.to_re "k") (re.++ (str.to_re "s") (re.++ (str.to_re " ") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re " ") (re.++ (str.to_re "J") (re.++ (str.to_re "a") (re.++ (str.to_re "v") (str.to_re "a")))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)