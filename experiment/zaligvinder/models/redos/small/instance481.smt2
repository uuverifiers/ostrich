;test regex \/media\/css\/[u|s]\.[a-f0-9]{32}\.[0-9]{10}\.css
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "/") (re.++ (str.to_re "m") (re.++ (str.to_re "e") (re.++ (str.to_re "d") (re.++ (str.to_re "i") (re.++ (str.to_re "a") (re.++ (str.to_re "/") (re.++ (str.to_re "c") (re.++ (str.to_re "s") (re.++ (str.to_re "s") (re.++ (str.to_re "/") (re.++ (re.union (str.to_re "u") (re.union (str.to_re "|") (str.to_re "s"))) (re.++ (str.to_re ".") (re.++ ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (re.++ (str.to_re ".") (re.++ ((_ re.loop 10 10) (re.range "0" "9")) (re.++ (str.to_re ".") (re.++ (str.to_re "c") (re.++ (str.to_re "s") (str.to_re "s"))))))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)