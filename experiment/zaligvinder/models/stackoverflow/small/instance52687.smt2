;test regex SEN \\d{1} \\w{8} \\w{1,2}( [-+]?[0-9]*\\.?[0-9]*){1,2}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "S") (re.++ (str.to_re "E") (re.++ (str.to_re "N") (re.++ (str.to_re " ") (re.++ (str.to_re "\\") (re.++ ((_ re.loop 1 1) (str.to_re "d")) (re.++ (str.to_re " ") (re.++ (str.to_re "\\") (re.++ ((_ re.loop 8 8) (str.to_re "w")) (re.++ (str.to_re " ") (re.++ (str.to_re "\\") (re.++ ((_ re.loop 1 2) (str.to_re "w")) ((_ re.loop 1 2) (re.++ (str.to_re " ") (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "+"))) (re.++ (re.* (re.range "0" "9")) (re.++ (str.to_re "\\") (re.++ (re.opt (re.diff re.allchar (str.to_re "\n"))) (re.* (re.range "0" "9"))))))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)