;test regex 24 hour format hh:mm:ss 
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "24") (re.++ (str.to_re " ") (re.++ (str.to_re "h") (re.++ (str.to_re "o") (re.++ (str.to_re "u") (re.++ (str.to_re "r") (re.++ (str.to_re " ") (re.++ (str.to_re "f") (re.++ (str.to_re "o") (re.++ (str.to_re "r") (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re " ") (re.++ (str.to_re "h") (re.++ (str.to_re "h") (re.++ (str.to_re ":") (re.++ (str.to_re "m") (re.++ (str.to_re "m") (re.++ (str.to_re ":") (re.++ (str.to_re "s") (re.++ (str.to_re "s") (str.to_re " ")))))))))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)