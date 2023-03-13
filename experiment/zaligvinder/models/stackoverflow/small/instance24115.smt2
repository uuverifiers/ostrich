;test regex final String re = "^[A-Z\\d]{2}[A-Z]?\\d{1,4}[A-Z]?$";
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "f") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "a") (re.++ (str.to_re "l") (re.++ (str.to_re " ") (re.++ (str.to_re "S") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "g") (re.++ (str.to_re " ") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re " ") (str.to_re "\u{22}"))))))))))))))))))) (re.++ (str.to_re "") (re.++ ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.union (str.to_re "\\") (str.to_re "d")))) (re.++ (re.opt (re.range "A" "Z")) (re.++ (str.to_re "\\") (re.++ ((_ re.loop 1 4) (str.to_re "d")) (re.opt (re.range "A" "Z")))))))) (re.++ (str.to_re "") (re.++ (str.to_re "\u{22}") (str.to_re ";"))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)