;test regex PageLocalize\("([A-Za-z]+)", "([A-Za-z0-9]{0,6})"\)
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "P") (re.++ (str.to_re "a") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "L") (re.++ (str.to_re "o") (re.++ (str.to_re "c") (re.++ (str.to_re "a") (re.++ (str.to_re "l") (re.++ (str.to_re "i") (re.++ (str.to_re "z") (re.++ (str.to_re "e") (re.++ (str.to_re "(") (re.++ (str.to_re "\u{22}") (re.++ (re.+ (re.union (re.range "A" "Z") (re.range "a" "z"))) (str.to_re "\u{22}")))))))))))))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ ((_ re.loop 0 6) (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9")))) (re.++ (str.to_re "\u{22}") (str.to_re ")")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)