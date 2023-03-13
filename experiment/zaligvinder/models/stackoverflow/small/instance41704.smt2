;test regex str.matches("(CO|CC|EX|FR)\\d{4}/\\d{1,8}")
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "c") (re.++ (str.to_re "h") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (re.++ (str.to_re "\u{22}") (re.++ (re.union (re.union (re.union (re.++ (str.to_re "C") (str.to_re "O")) (re.++ (str.to_re "C") (str.to_re "C"))) (re.++ (str.to_re "E") (str.to_re "X"))) (re.++ (str.to_re "F") (str.to_re "R"))) (re.++ (str.to_re "\\") (re.++ ((_ re.loop 4 4) (str.to_re "d")) (re.++ (str.to_re "/") (re.++ (str.to_re "\\") (re.++ ((_ re.loop 1 8) (str.to_re "d")) (str.to_re "\u{22}")))))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)