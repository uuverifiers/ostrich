;test regex /^[A-Za-z]+((-[A-Za-z]{1,})+)?$/.test('abc'); // Logs true
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "/") (re.++ (str.to_re "") (re.++ (re.+ (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.opt (re.+ (re.++ (str.to_re "-") (re.++ (re.* (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 1 1) (re.union (re.range "A" "Z") (re.range "a" "z")))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "/") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "a") (re.++ (str.to_re "b") (re.++ (str.to_re "c") (str.to_re "\u{27}"))))) (re.++ (str.to_re ";") (re.++ (str.to_re " ") (re.++ (str.to_re "/") (re.++ (str.to_re "/") (re.++ (str.to_re " ") (re.++ (str.to_re "L") (re.++ (str.to_re "o") (re.++ (str.to_re "g") (re.++ (str.to_re "s") (re.++ (str.to_re " ") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re "u") (str.to_re "e")))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)