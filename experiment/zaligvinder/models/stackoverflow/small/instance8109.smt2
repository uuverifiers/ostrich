;test regex parameterName + "[\\s\\S]*DATA\\s0x[0-9A-F]{4,8}"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "p") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.++ (str.to_re "a") (re.++ (str.to_re "m") (re.++ (str.to_re "e") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "N") (re.++ (str.to_re "a") (re.++ (str.to_re "m") (re.++ (str.to_re "e") (re.++ (re.+ (str.to_re " ")) (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ (re.* (re.union (str.to_re "\\") (re.union (str.to_re "s") (re.union (str.to_re "\\") (str.to_re "S"))))) (re.++ (str.to_re "D") (re.++ (str.to_re "A") (re.++ (str.to_re "T") (re.++ (str.to_re "A") (re.++ (str.to_re "\\") (re.++ (str.to_re "s") (re.++ (str.to_re "0") (re.++ (str.to_re "x") (re.++ ((_ re.loop 4 8) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re "\u{22}")))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)