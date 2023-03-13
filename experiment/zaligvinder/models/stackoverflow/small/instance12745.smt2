;test regex Regex1 = "/(?:\\s(F|A|E)?\\d{6}\\s?+.*?\r\n\\s?\r\n)\\K//ms";
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "R") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re "1") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "/") (re.++ (re.++ (str.to_re "\\") (re.++ (str.to_re "s") (re.++ (re.opt (re.union (re.union (str.to_re "F") (str.to_re "A")) (str.to_re "E"))) (re.++ (str.to_re "\\") (re.++ ((_ re.loop 6 6) (str.to_re "d")) (re.++ (str.to_re "\\") (re.++ (re.+ (re.opt (str.to_re "s"))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "\u{0d}") (re.++ (str.to_re "\u{0a}") (re.++ (str.to_re "\\") (re.++ (re.opt (str.to_re "s")) (re.++ (str.to_re "\u{0d}") (str.to_re "\u{0a}")))))))))))))) (re.++ (str.to_re "\\") (re.++ (str.to_re "K") (re.++ (str.to_re "/") (re.++ (str.to_re "/") (re.++ (str.to_re "m") (re.++ (str.to_re "s") (re.++ (str.to_re "\u{22}") (str.to_re ";"))))))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)