;test regex "^(C[OC]|EX|FR)\\d{4}/\\d{1,8}$"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "") (re.++ (re.union (re.union (re.++ (str.to_re "C") (re.union (str.to_re "O") (str.to_re "C"))) (re.++ (str.to_re "E") (str.to_re "X"))) (re.++ (str.to_re "F") (str.to_re "R"))) (re.++ (str.to_re "\\") (re.++ ((_ re.loop 4 4) (str.to_re "d")) (re.++ (str.to_re "/") (re.++ (str.to_re "\\") ((_ re.loop 1 8) (str.to_re "d"))))))))) (re.++ (str.to_re "") (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)