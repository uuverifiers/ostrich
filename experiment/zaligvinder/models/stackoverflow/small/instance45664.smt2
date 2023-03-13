;test regex ^[A-Za-z]{5}\.[A-Za-z]{2}\.INPUT.[0-9]*\.[A-Za-z0-9]+\.[0-9]+(.TXT|.txt)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 5 5) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.++ (str.to_re ".") (re.++ ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.++ (str.to_re ".") (re.++ (str.to_re "I") (re.++ (str.to_re "N") (re.++ (str.to_re "P") (re.++ (str.to_re "U") (re.++ (str.to_re "T") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.* (re.range "0" "9")) (re.++ (str.to_re ".") (re.++ (re.+ (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9")))) (re.++ (str.to_re ".") (re.++ (re.+ (re.range "0" "9")) (re.union (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "T") (re.++ (str.to_re "X") (str.to_re "T")))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "t") (re.++ (str.to_re "x") (str.to_re "t"))))))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)