;test regex ^([a-zA-Z0-9]*-){5}[a-zA-Z0-9]*$ # Match exactly 5 -
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 5 5) (re.++ (re.* (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9")))) (str.to_re "-"))) (re.* (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.range "0" "9")))))) (re.++ (str.to_re "") (re.++ (str.to_re " ") (re.++ (str.to_re "#") (re.++ (str.to_re " ") (re.++ (str.to_re "M") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "c") (re.++ (str.to_re "h") (re.++ (str.to_re " ") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re "a") (re.++ (str.to_re "c") (re.++ (str.to_re "t") (re.++ (str.to_re "l") (re.++ (str.to_re "y") (re.++ (str.to_re " ") (re.++ (str.to_re "5") (re.++ (str.to_re " ") (str.to_re "-"))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)