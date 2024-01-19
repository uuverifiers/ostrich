;test regex http:\/\/imgur\.com\/.{5,8}\.(jpg|jpeg|gif|png)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "h") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "p") (re.++ (str.to_re ":") (re.++ (str.to_re "/") (re.++ (str.to_re "/") (re.++ (str.to_re "i") (re.++ (str.to_re "m") (re.++ (str.to_re "g") (re.++ (str.to_re "u") (re.++ (str.to_re "r") (re.++ (str.to_re ".") (re.++ (str.to_re "c") (re.++ (str.to_re "o") (re.++ (str.to_re "m") (re.++ (str.to_re "/") (re.++ ((_ re.loop 5 8) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re ".") (re.union (re.union (re.union (re.++ (str.to_re "j") (re.++ (str.to_re "p") (str.to_re "g"))) (re.++ (str.to_re "j") (re.++ (str.to_re "p") (re.++ (str.to_re "e") (str.to_re "g"))))) (re.++ (str.to_re "g") (re.++ (str.to_re "i") (str.to_re "f")))) (re.++ (str.to_re "p") (re.++ (str.to_re "n") (str.to_re "g")))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)