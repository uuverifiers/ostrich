;test regex (FA.{0,2}EX|EX.{0,2}FA)
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "F") (re.++ (str.to_re "A") (re.++ ((_ re.loop 0 2) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "E") (str.to_re "X"))))) (re.++ (str.to_re "E") (re.++ (str.to_re "X") (re.++ ((_ re.loop 0 2) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "F") (str.to_re "A"))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)