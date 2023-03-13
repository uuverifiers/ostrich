;test regex String pattern="[a-z]{2,}[A-Z]{2,}[0-9]{2,}[@#$%&]{2,}";
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "S") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "g") (re.++ (str.to_re " ") (re.++ (str.to_re "p") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "n") (re.++ (str.to_re "=") (re.++ (str.to_re "\u{22}") (re.++ (re.++ (re.* (re.range "a" "z")) ((_ re.loop 2 2) (re.range "a" "z"))) (re.++ (re.++ (re.* (re.range "A" "Z")) ((_ re.loop 2 2) (re.range "A" "Z"))) (re.++ (re.++ (re.* (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (re.++ (re.* (re.union (str.to_re "@") (re.union (str.to_re "#") (re.union (str.to_re "$") (re.union (str.to_re "%") (str.to_re "&")))))) ((_ re.loop 2 2) (re.union (str.to_re "@") (re.union (str.to_re "#") (re.union (str.to_re "$") (re.union (str.to_re "%") (str.to_re "&"))))))) (re.++ (str.to_re "\u{22}") (str.to_re ";"))))))))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)