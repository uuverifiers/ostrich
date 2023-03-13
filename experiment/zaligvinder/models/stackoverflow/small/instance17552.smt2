;test regex BRANCH_REGEX="[0-9]{10}-[^_]*_[0-9]{13}"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "B") (re.++ (str.to_re "R") (re.++ (str.to_re "A") (re.++ (str.to_re "N") (re.++ (str.to_re "C") (re.++ (str.to_re "H") (re.++ (str.to_re "_") (re.++ (str.to_re "R") (re.++ (str.to_re "E") (re.++ (str.to_re "G") (re.++ (str.to_re "E") (re.++ (str.to_re "X") (re.++ (str.to_re "=") (re.++ (str.to_re "\u{22}") (re.++ ((_ re.loop 10 10) (re.range "0" "9")) (re.++ (str.to_re "-") (re.++ (re.* (re.diff re.allchar (str.to_re "_"))) (re.++ (str.to_re "_") (re.++ ((_ re.loop 13 13) (re.range "0" "9")) (str.to_re "\u{22}"))))))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)