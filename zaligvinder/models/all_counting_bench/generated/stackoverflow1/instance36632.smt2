;test regex NSString *vowelsAsRegex = @"[\u0591-\u05c4]{0,2}";
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "N") (re.++ (str.to_re "S") (re.++ (str.to_re "S") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "g") (re.++ (re.* (str.to_re " ")) (re.++ (str.to_re "v") (re.++ (str.to_re "o") (re.++ (str.to_re "w") (re.++ (str.to_re "e") (re.++ (str.to_re "l") (re.++ (str.to_re "s") (re.++ (str.to_re "A") (re.++ (str.to_re "s") (re.++ (str.to_re "R") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re " ") (re.++ (str.to_re "@") (re.++ (str.to_re "\u{22}") (re.++ ((_ re.loop 0 2) (re.range "\u{0591}" "\u{05c4}")) (re.++ (str.to_re "\u{22}") (str.to_re ";"))))))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)