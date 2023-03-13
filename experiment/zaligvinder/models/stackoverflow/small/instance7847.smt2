;test regex ^(HTTP|http)/(1|2)\\.\\d \\d{3}(.|\\s)+$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.++ (str.to_re "H") (re.++ (str.to_re "T") (re.++ (str.to_re "T") (str.to_re "P")))) (re.++ (str.to_re "h") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (str.to_re "p"))))) (re.++ (str.to_re "/") (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.++ (str.to_re "\\") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "\\") (re.++ (str.to_re "d") (re.++ (str.to_re " ") (re.++ (str.to_re "\\") (re.++ ((_ re.loop 3 3) (str.to_re "d")) (re.+ (re.union (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "\\") (str.to_re "s"))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)