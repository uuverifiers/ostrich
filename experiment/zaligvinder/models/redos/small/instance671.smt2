;test regex ^  (.{40,}) - (OK|NOT FOUND|CORRUPT|FOUND: (.*))$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re " ") (re.++ (str.to_re " ") (re.++ (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) ((_ re.loop 40 40) (re.diff re.allchar (str.to_re "\n")))) (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (str.to_re " ") (re.union (re.union (re.union (re.++ (str.to_re "O") (str.to_re "K")) (re.++ (str.to_re "N") (re.++ (str.to_re "O") (re.++ (str.to_re "T") (re.++ (str.to_re " ") (re.++ (str.to_re "F") (re.++ (str.to_re "O") (re.++ (str.to_re "U") (re.++ (str.to_re "N") (str.to_re "D")))))))))) (re.++ (str.to_re "C") (re.++ (str.to_re "O") (re.++ (str.to_re "R") (re.++ (str.to_re "R") (re.++ (str.to_re "U") (re.++ (str.to_re "P") (str.to_re "T")))))))) (re.++ (str.to_re "F") (re.++ (str.to_re "O") (re.++ (str.to_re "U") (re.++ (str.to_re "N") (re.++ (str.to_re "D") (re.++ (str.to_re ":") (re.++ (str.to_re " ") (re.* (re.diff re.allchar (str.to_re "\n")))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)