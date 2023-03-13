;test regex (?:\\\\u05[dDeE][0-9a-fA-F]){2,}
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.++ (str.to_re "\\") (re.++ (str.to_re "\\") (re.++ (str.to_re "u") (re.++ (str.to_re "05") (re.++ (re.union (str.to_re "d") (re.union (str.to_re "D") (re.union (str.to_re "e") (str.to_re "E")))) (re.union (re.range "0" "9") (re.union (re.range "a" "f") (re.range "A" "F"))))))))) ((_ re.loop 2 2) (re.++ (str.to_re "\\") (re.++ (str.to_re "\\") (re.++ (str.to_re "u") (re.++ (str.to_re "05") (re.++ (re.union (str.to_re "d") (re.union (str.to_re "D") (re.union (str.to_re "e") (str.to_re "E")))) (re.union (re.range "0" "9") (re.union (re.range "a" "f") (re.range "A" "F"))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)