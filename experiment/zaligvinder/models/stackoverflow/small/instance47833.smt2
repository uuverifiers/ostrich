;test regex https:\/\/([a-z]{0,2})\.?blah\.com(?:\/(.*))?\/required\/B([A-Z0-9]{9}).*
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "h") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "p") (re.++ (str.to_re "s") (re.++ (str.to_re ":") (re.++ (str.to_re "/") (re.++ (str.to_re "/") (re.++ ((_ re.loop 0 2) (re.range "a" "z")) (re.++ (re.opt (str.to_re ".")) (re.++ (str.to_re "b") (re.++ (str.to_re "l") (re.++ (str.to_re "a") (re.++ (str.to_re "h") (re.++ (str.to_re ".") (re.++ (str.to_re "c") (re.++ (str.to_re "o") (re.++ (str.to_re "m") (re.++ (re.opt (re.++ (str.to_re "/") (re.* (re.diff re.allchar (str.to_re "\n"))))) (re.++ (str.to_re "/") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "q") (re.++ (str.to_re "u") (re.++ (str.to_re "i") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "d") (re.++ (str.to_re "/") (re.++ (str.to_re "B") (re.++ ((_ re.loop 9 9) (re.union (re.range "A" "Z") (re.range "0" "9"))) (re.* (re.diff re.allchar (str.to_re "\n"))))))))))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)