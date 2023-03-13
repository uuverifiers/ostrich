;test regex (\w+ ){0,5}FINDTHISWORD( \w+){0,5}
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 0 5) (re.++ (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (str.to_re " "))) (re.++ (str.to_re "F") (re.++ (str.to_re "I") (re.++ (str.to_re "N") (re.++ (str.to_re "D") (re.++ (str.to_re "T") (re.++ (str.to_re "H") (re.++ (str.to_re "I") (re.++ (str.to_re "S") (re.++ (str.to_re "W") (re.++ (str.to_re "O") (re.++ (str.to_re "R") (re.++ (str.to_re "D") ((_ re.loop 0 5) (re.++ (str.to_re " ") (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)