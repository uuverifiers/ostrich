;test regex grep -E -o "^[0-9]{23}[^0-9]+[0-9]+" MYFILE.TXT
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "g") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (str.to_re "E") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (str.to_re "o") (re.++ (str.to_re " ") (str.to_re "\u{22}")))))))))))) (re.++ (str.to_re "") (re.++ ((_ re.loop 23 23) (re.range "0" "9")) (re.++ (re.+ (re.diff re.allchar (re.range "0" "9"))) (re.++ (re.+ (re.range "0" "9")) (re.++ (str.to_re "\u{22}") (re.++ (str.to_re " ") (re.++ (str.to_re "M") (re.++ (str.to_re "Y") (re.++ (str.to_re "F") (re.++ (str.to_re "I") (re.++ (str.to_re "L") (re.++ (str.to_re "E") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "T") (re.++ (str.to_re "X") (str.to_re "T")))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)