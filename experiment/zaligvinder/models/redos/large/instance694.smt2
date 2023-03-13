;test regex  ?< ?(span|div|table|data) [a-zA-Z0-9= ]{2,100}\/? ?> ?
(declare-const X String)
(assert (str.in_re X (re.++ (re.opt (str.to_re " ")) (re.++ (str.to_re "<") (re.++ (re.opt (str.to_re " ")) (re.++ (re.union (re.union (re.union (re.++ (str.to_re "s") (re.++ (str.to_re "p") (re.++ (str.to_re "a") (str.to_re "n")))) (re.++ (str.to_re "d") (re.++ (str.to_re "i") (str.to_re "v")))) (re.++ (str.to_re "t") (re.++ (str.to_re "a") (re.++ (str.to_re "b") (re.++ (str.to_re "l") (str.to_re "e")))))) (re.++ (str.to_re "d") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (str.to_re "a"))))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 2 100) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (re.union (str.to_re "=") (str.to_re " ")))))) (re.++ (re.opt (str.to_re "/")) (re.++ (re.opt (str.to_re " ")) (re.++ (str.to_re ">") (re.opt (str.to_re " ")))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)