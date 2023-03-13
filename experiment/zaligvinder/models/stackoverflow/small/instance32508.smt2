;test regex Resolution: (.*)(\n {6}.*)*\n {6}Main Display: Yes
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "R") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (re.++ (str.to_re "o") (re.++ (str.to_re "l") (re.++ (str.to_re "u") (re.++ (str.to_re "t") (re.++ (str.to_re "i") (re.++ (str.to_re "o") (re.++ (str.to_re "n") (re.++ (str.to_re ":") (re.++ (str.to_re " ") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.* (re.++ (str.to_re "\u{0a}") (re.++ ((_ re.loop 6 6) (str.to_re " ")) (re.* (re.diff re.allchar (str.to_re "\n")))))) (re.++ (str.to_re "\u{0a}") (re.++ ((_ re.loop 6 6) (str.to_re " ")) (re.++ (str.to_re "M") (re.++ (str.to_re "a") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re " ") (re.++ (str.to_re "D") (re.++ (str.to_re "i") (re.++ (str.to_re "s") (re.++ (str.to_re "p") (re.++ (str.to_re "l") (re.++ (str.to_re "a") (re.++ (str.to_re "y") (re.++ (str.to_re ":") (re.++ (str.to_re " ") (re.++ (str.to_re "Y") (re.++ (str.to_re "e") (str.to_re "s")))))))))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)