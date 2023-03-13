;test regex test := RegExMatch("1234AB123","[0-9]{4,4}([A-Z]{2})[0-9]{1,3}")
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re " ") (re.++ (str.to_re ":") (re.++ (str.to_re "=") (re.++ (str.to_re " ") (re.++ (str.to_re "R") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "E") (re.++ (str.to_re "x") (re.++ (str.to_re "M") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "c") (re.++ (str.to_re "h") (re.++ (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "1234") (re.++ (str.to_re "A") (re.++ (str.to_re "B") (re.++ (str.to_re "123") (str.to_re "\u{22}")))))) (re.++ (str.to_re ",") (re.++ (str.to_re "\u{22}") (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ ((_ re.loop 2 2) (re.range "A" "Z")) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "\u{22}")))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)