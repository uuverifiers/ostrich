;test regex ([PDO]\\.){2}\\s?B(ox|\\.)\\s?\\d+
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.++ (re.union (str.to_re "P") (re.union (str.to_re "D") (str.to_re "O"))) (re.++ (str.to_re "\\") (re.diff re.allchar (str.to_re "\n"))))) (re.++ (str.to_re "\\") (re.++ (re.opt (str.to_re "s")) (re.++ (str.to_re "B") (re.++ (re.union (re.++ (str.to_re "o") (str.to_re "x")) (re.++ (str.to_re "\\") (re.diff re.allchar (str.to_re "\n")))) (re.++ (str.to_re "\\") (re.++ (re.opt (str.to_re "s")) (re.++ (str.to_re "\\") (re.+ (str.to_re "d"))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)