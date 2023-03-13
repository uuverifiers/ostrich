;test regex (messag|courrier|zimbra|imp|mail)(.*)\.(.*)\..{2,4}
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.union (re.union (re.union (re.++ (str.to_re "m") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (re.++ (str.to_re "s") (re.++ (str.to_re "a") (str.to_re "g")))))) (re.++ (str.to_re "c") (re.++ (str.to_re "o") (re.++ (str.to_re "u") (re.++ (str.to_re "r") (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "e") (str.to_re "r"))))))))) (re.++ (str.to_re "z") (re.++ (str.to_re "i") (re.++ (str.to_re "m") (re.++ (str.to_re "b") (re.++ (str.to_re "r") (str.to_re "a"))))))) (re.++ (str.to_re "i") (re.++ (str.to_re "m") (str.to_re "p")))) (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "i") (str.to_re "l"))))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re ".") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re ".") ((_ re.loop 2 4) (re.diff re.allchar (str.to_re "\n"))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)