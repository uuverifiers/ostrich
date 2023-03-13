;test regex String regEx = "\\(\\+\\d{2}\\)-\\(\\d{2}\\)-\\d+";
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "S") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "g") (re.++ (str.to_re " ") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "E") (re.++ (str.to_re "x") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "\\") (re.++ (re.++ (re.+ (str.to_re "\\")) (re.++ (str.to_re "\\") (re.++ ((_ re.loop 2 2) (str.to_re "d")) (str.to_re "\\")))) (re.++ (str.to_re "-") (re.++ (str.to_re "\\") (re.++ (re.++ (str.to_re "\\") (re.++ ((_ re.loop 2 2) (str.to_re "d")) (str.to_re "\\"))) (re.++ (str.to_re "-") (re.++ (str.to_re "\\") (re.++ (re.+ (str.to_re "d")) (re.++ (str.to_re "\u{22}") (str.to_re ";"))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)