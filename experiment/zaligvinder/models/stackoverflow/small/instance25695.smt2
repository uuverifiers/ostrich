;test regex "?:(.*);GRAYSCALE=([0-9]{1,2}|1[0-9]{2}|2[0-4][0-9]|25[0-5])(?:;\\w*)?"
(declare-const X String)
(assert (str.in_re X (re.++ (re.opt (str.to_re "\u{22}")) (re.++ (str.to_re ":") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re ";") (re.++ (str.to_re "G") (re.++ (str.to_re "R") (re.++ (str.to_re "A") (re.++ (str.to_re "Y") (re.++ (str.to_re "S") (re.++ (str.to_re "C") (re.++ (str.to_re "A") (re.++ (str.to_re "L") (re.++ (str.to_re "E") (re.++ (str.to_re "=") (re.++ (re.union (re.union (re.union ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (str.to_re "1") ((_ re.loop 2 2) (re.range "0" "9")))) (re.++ (str.to_re "2") (re.++ (re.range "0" "4") (re.range "0" "9")))) (re.++ (str.to_re "25") (re.range "0" "5"))) (re.++ (re.opt (re.++ (str.to_re ";") (re.++ (str.to_re "\\") (re.* (str.to_re "w"))))) (str.to_re "\u{22}")))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)