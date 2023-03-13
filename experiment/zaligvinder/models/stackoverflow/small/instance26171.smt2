;test regex xyz.{0,25}pqr
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "x") (re.++ (str.to_re "y") (re.++ (str.to_re "z") (re.++ ((_ re.loop 0 25) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "p") (re.++ (str.to_re "q") (str.to_re "r")))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)