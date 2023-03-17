;test regex SELECT * FROM users WHERE seo LIKE '%[0-9]{6}%'
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "S") (re.++ (str.to_re "E") (re.++ (str.to_re "L") (re.++ (str.to_re "E") (re.++ (str.to_re "C") (re.++ (str.to_re "T") (re.++ (re.* (str.to_re " ")) (re.++ (str.to_re " ") (re.++ (str.to_re "F") (re.++ (str.to_re "R") (re.++ (str.to_re "O") (re.++ (str.to_re "M") (re.++ (str.to_re " ") (re.++ (str.to_re "u") (re.++ (str.to_re "s") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "s") (re.++ (str.to_re " ") (re.++ (str.to_re "W") (re.++ (str.to_re "H") (re.++ (str.to_re "E") (re.++ (str.to_re "R") (re.++ (str.to_re "E") (re.++ (str.to_re " ") (re.++ (str.to_re "s") (re.++ (str.to_re "e") (re.++ (str.to_re "o") (re.++ (str.to_re " ") (re.++ (str.to_re "L") (re.++ (str.to_re "I") (re.++ (str.to_re "K") (re.++ (str.to_re "E") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "%") (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (re.++ (str.to_re "%") (str.to_re "\u{27}")))))))))))))))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)