;test regex (?:\Qfoo\E)?.{0,3}(?:\Qbar\E)?.{0,3}(?:\Qbaz\E)?
(declare-const X String)
(assert (str.in_re X (re.++ (re.opt (re.++ (str.to_re "Q") (re.++ (str.to_re "f") (re.++ (str.to_re "o") (re.++ (str.to_re "o") (str.to_re "E")))))) (re.++ ((_ re.loop 0 3) (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.opt (re.++ (str.to_re "Q") (re.++ (str.to_re "b") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (str.to_re "E")))))) (re.++ ((_ re.loop 0 3) (re.diff re.allchar (str.to_re "\n"))) (re.opt (re.++ (str.to_re "Q") (re.++ (str.to_re "b") (re.++ (str.to_re "a") (re.++ (str.to_re "z") (str.to_re "E"))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)