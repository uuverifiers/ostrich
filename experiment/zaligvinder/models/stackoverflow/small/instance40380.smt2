;test regex string = \"((\\(\"|\\|\/|b|f|n|r|t|u[0-9a-fA-F]{4})) | [^\"\\])*\"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "g") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ (re.* (re.union (re.++ (re.++ (str.to_re "\\") (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (str.to_re "\u{22}") (str.to_re "\\")) (str.to_re "/")) (str.to_re "b")) (str.to_re "f")) (str.to_re "n")) (str.to_re "r")) (str.to_re "t")) (re.++ (str.to_re "u") ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.union (re.range "a" "f") (re.range "A" "F"))))))) (str.to_re " ")) (re.++ (str.to_re " ") (re.inter (re.diff re.allchar (str.to_re "\u{22}")) (re.diff re.allchar (str.to_re "\\")))))) (str.to_re "\u{22}"))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)