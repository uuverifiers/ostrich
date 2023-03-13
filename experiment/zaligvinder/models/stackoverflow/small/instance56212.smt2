;test regex (?:\\w+ (?:INT|CHAR(?:\\(\\d{1,3}\\))?|DEC)(?:, )?)+
(declare-const X String)
(assert (str.in_re X (re.+ (re.++ (str.to_re "\\") (re.++ (re.+ (str.to_re "w")) (re.++ (str.to_re " ") (re.++ (re.union (re.union (re.++ (str.to_re "I") (re.++ (str.to_re "N") (str.to_re "T"))) (re.++ (str.to_re "C") (re.++ (str.to_re "H") (re.++ (str.to_re "A") (re.++ (str.to_re "R") (re.opt (re.++ (str.to_re "\\") (re.++ (str.to_re "\\") (re.++ ((_ re.loop 1 3) (str.to_re "d")) (str.to_re "\\")))))))))) (re.++ (str.to_re "D") (re.++ (str.to_re "E") (str.to_re "C")))) (re.opt (re.++ (str.to_re ",") (str.to_re " "))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)