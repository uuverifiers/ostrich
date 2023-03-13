;test regex "YOUR SET ADDRESS IS ( [A-Z0-9]{6})*"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "Y") (re.++ (str.to_re "O") (re.++ (str.to_re "U") (re.++ (str.to_re "R") (re.++ (str.to_re " ") (re.++ (str.to_re "S") (re.++ (str.to_re "E") (re.++ (str.to_re "T") (re.++ (str.to_re " ") (re.++ (str.to_re "A") (re.++ (str.to_re "D") (re.++ (str.to_re "D") (re.++ (str.to_re "R") (re.++ (str.to_re "E") (re.++ (str.to_re "S") (re.++ (str.to_re "S") (re.++ (str.to_re " ") (re.++ (str.to_re "I") (re.++ (str.to_re "S") (re.++ (str.to_re " ") (re.++ (re.* (re.++ (str.to_re " ") ((_ re.loop 6 6) (re.union (re.range "A" "Z") (re.range "0" "9"))))) (str.to_re "\u{22}")))))))))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)