;test regex SomeData\n([-+]?[0-9\n]+[0-9,\n]*(?:\.[0-9\n]+)?[ \n]){6,6}SomeData
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "S") (re.++ (str.to_re "o") (re.++ (str.to_re "m") (re.++ (str.to_re "e") (re.++ (str.to_re "D") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "a") (re.++ (str.to_re "\u{0a}") (re.++ ((_ re.loop 6 6) (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "+"))) (re.++ (re.+ (re.union (re.range "0" "9") (str.to_re "\u{0a}"))) (re.++ (re.* (re.union (re.range "0" "9") (re.union (str.to_re ",") (str.to_re "\u{0a}")))) (re.++ (re.opt (re.++ (str.to_re ".") (re.+ (re.union (re.range "0" "9") (str.to_re "\u{0a}"))))) (re.union (str.to_re " ") (str.to_re "\u{0a}"))))))) (re.++ (str.to_re "S") (re.++ (str.to_re "o") (re.++ (str.to_re "m") (re.++ (str.to_re "e") (re.++ (str.to_re "D") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (str.to_re "a"))))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)