;test regex [^ \n]{1,}(@mazur.com)
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.* (re.inter (re.diff re.allchar (str.to_re " ")) (re.diff re.allchar (str.to_re "\u{0a}")))) ((_ re.loop 1 1) (re.inter (re.diff re.allchar (str.to_re " ")) (re.diff re.allchar (str.to_re "\u{0a}"))))) (re.++ (str.to_re "@") (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "z") (re.++ (str.to_re "u") (re.++ (str.to_re "r") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "c") (re.++ (str.to_re "o") (str.to_re "m")))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)