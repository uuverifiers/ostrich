;test regex ^(USA|Italy|France|.{0})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union (re.union (re.++ (str.to_re "U") (re.++ (str.to_re "S") (str.to_re "A"))) (re.++ (str.to_re "I") (re.++ (str.to_re "t") (re.++ (str.to_re "a") (re.++ (str.to_re "l") (str.to_re "y")))))) (re.++ (str.to_re "F") (re.++ (str.to_re "r") (re.++ (str.to_re "a") (re.++ (str.to_re "n") (re.++ (str.to_re "c") (str.to_re "e"))))))) ((_ re.loop 0 0) (re.diff re.allchar (str.to_re "\n"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)