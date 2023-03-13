;test regex A.{50}\\r?\\n(?:B.{50}(?:\\r?\\n)?)+
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "A") (re.++ ((_ re.loop 50 50) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "\\") (re.++ (re.opt (str.to_re "r")) (re.++ (str.to_re "\\") (re.++ (str.to_re "n") (re.+ (re.++ (str.to_re "B") (re.++ ((_ re.loop 50 50) (re.diff re.allchar (str.to_re "\n"))) (re.opt (re.++ (str.to_re "\\") (re.++ (re.opt (str.to_re "r")) (re.++ (str.to_re "\\") (str.to_re "n"))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)