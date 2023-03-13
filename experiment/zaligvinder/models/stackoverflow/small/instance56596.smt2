;test regex regexp ="^([a-z]{2},[a-z0-9]{1,5},[a-z]{3},[a-z]{3},[a-z]{1}(,[a-z0-9]{1,25})?)+$"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re "p") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (str.to_re "\u{22}"))))))))) (re.++ (str.to_re "") (re.+ (re.++ (re.++ (re.++ (re.++ ((_ re.loop 2 2) (re.range "a" "z")) (re.++ (str.to_re ",") ((_ re.loop 1 5) (re.union (re.range "a" "z") (re.range "0" "9"))))) (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "a" "z")))) (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "a" "z")))) (re.++ (str.to_re ",") (re.++ ((_ re.loop 1 1) (re.range "a" "z")) (re.opt (re.++ (str.to_re ",") ((_ re.loop 1 25) (re.union (re.range "a" "z") (re.range "0" "9"))))))))))) (re.++ (str.to_re "") (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)