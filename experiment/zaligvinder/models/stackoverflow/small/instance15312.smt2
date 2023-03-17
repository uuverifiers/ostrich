;test regex HREF=".*\.jsp\?.*N=[0-9]{1,}+N=[0-9]{1,}+N=[0-9]{1,}...*"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "H") (re.++ (str.to_re "R") (re.++ (str.to_re "E") (re.++ (str.to_re "F") (re.++ (str.to_re "=") (re.++ (str.to_re "\u{22}") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re ".") (re.++ (str.to_re "j") (re.++ (str.to_re "s") (re.++ (str.to_re "p") (re.++ (str.to_re "?") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "N") (re.++ (str.to_re "=") (re.++ (re.+ (re.++ (re.* (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9")))) (re.++ (str.to_re "N") (re.++ (str.to_re "=") (re.++ (re.+ (re.++ (re.* (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9")))) (re.++ (str.to_re "N") (re.++ (str.to_re "=") (re.++ (re.++ (re.* (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (str.to_re "\u{22}"))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)