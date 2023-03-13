;test regex r"(.{20})?(1500)(.{20})?" g
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "r") (re.++ (str.to_re "\u{22}") (re.++ (re.opt ((_ re.loop 20 20) (re.diff re.allchar (str.to_re "\n")))) (re.++ (str.to_re "1500") (re.++ (re.opt ((_ re.loop 20 20) (re.diff re.allchar (str.to_re "\n")))) (re.++ (str.to_re "\u{22}") (re.++ (str.to_re " ") (str.to_re "g"))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)