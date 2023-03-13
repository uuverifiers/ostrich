;test regex String patter = ^LG{1}[a-z][A-Z]{10}[0-9]{6}[0-9]{5}
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "S") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "g") (re.++ (str.to_re " ") (re.++ (str.to_re "p") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (str.to_re " ")))))))))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "L") (re.++ ((_ re.loop 1 1) (str.to_re "G")) (re.++ (re.range "a" "z") (re.++ ((_ re.loop 10 10) (re.range "A" "Z")) (re.++ ((_ re.loop 6 6) (re.range "0" "9")) ((_ re.loop 5 5) (re.range "0" "9")))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)