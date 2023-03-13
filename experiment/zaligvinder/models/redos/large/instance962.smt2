;test regex .*IHEGFJDCA[BD-J]{60,60}A.*
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "I") (re.++ (str.to_re "H") (re.++ (str.to_re "E") (re.++ (str.to_re "G") (re.++ (str.to_re "F") (re.++ (str.to_re "J") (re.++ (str.to_re "D") (re.++ (str.to_re "C") (re.++ (str.to_re "A") (re.++ ((_ re.loop 60 60) (re.union (str.to_re "B") (re.range "D" "J"))) (re.++ (str.to_re "A") (re.* (re.diff re.allchar (str.to_re "\n")))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)