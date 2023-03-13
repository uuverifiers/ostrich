;test regex (.+\n){2}.+ViewRoles.+\n.+
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.++ (re.+ (re.diff re.allchar (str.to_re "\n"))) (str.to_re "\u{0a}"))) (re.++ (re.+ (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "V") (re.++ (str.to_re "i") (re.++ (str.to_re "e") (re.++ (str.to_re "w") (re.++ (str.to_re "R") (re.++ (str.to_re "o") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (re.++ (re.+ (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "\u{0a}") (re.+ (re.diff re.allchar (str.to_re "\n"))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)