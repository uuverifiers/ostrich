;test regex /^((00)|(\+))961((\d)|(7[0168]))\d{6}$/.test("009617612345"); // true
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "/") (re.++ (str.to_re "") (re.++ (re.union (str.to_re "00") (str.to_re "+")) (re.++ (str.to_re "961") (re.++ (re.union (re.range "0" "9") (re.++ (str.to_re "7") (str.to_re "0168"))) ((_ re.loop 6 6) (re.range "0" "9"))))))) (re.++ (str.to_re "") (re.++ (str.to_re "/") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "009617612345") (str.to_re "\u{22}"))) (re.++ (str.to_re ";") (re.++ (str.to_re " ") (re.++ (str.to_re "/") (re.++ (str.to_re "/") (re.++ (str.to_re " ") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re "u") (str.to_re "e"))))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)