;test regex [fF][oO]{2}[- ()][bB][aA][rR]
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (str.to_re "f") (str.to_re "F")) (re.++ ((_ re.loop 2 2) (re.union (str.to_re "o") (str.to_re "O"))) (re.++ (re.union (str.to_re "-") (re.union (str.to_re " ") (re.union (str.to_re "(") (str.to_re ")")))) (re.++ (re.union (str.to_re "b") (str.to_re "B")) (re.++ (re.union (str.to_re "a") (str.to_re "A")) (re.union (str.to_re "r") (str.to_re "R")))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)