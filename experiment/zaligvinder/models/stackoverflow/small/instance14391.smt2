;test regex (^.*)(ERROR.*\n)(.*\n)(.*\n){2}(.*(\n|$))*
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.* (re.diff re.allchar (str.to_re "\n")))) (re.++ (re.++ (str.to_re "E") (re.++ (str.to_re "R") (re.++ (str.to_re "R") (re.++ (str.to_re "O") (re.++ (str.to_re "R") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (str.to_re "\u{0a}"))))))) (re.++ (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (str.to_re "\u{0a}")) (re.++ ((_ re.loop 2 2) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (str.to_re "\u{0a}"))) (re.* (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.union (str.to_re "\u{0a}") (str.to_re ""))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)