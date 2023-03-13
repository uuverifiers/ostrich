;test regex VCS([a-zA-Z]*$)_[0-9]{8}_OMEGA.csv
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "V") (re.++ (str.to_re "C") (re.++ (str.to_re "S") (re.++ (re.++ (re.* (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "")) (re.++ (str.to_re "_") (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (re.++ (str.to_re "_") (re.++ (str.to_re "O") (re.++ (str.to_re "M") (re.++ (str.to_re "E") (re.++ (str.to_re "G") (re.++ (str.to_re "A") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "c") (re.++ (str.to_re "s") (str.to_re "v"))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)