;test regex splitRegex (mkRegex "2013[0-9]{11}AH021") myData
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "s") (re.++ (str.to_re "p") (re.++ (str.to_re "l") (re.++ (str.to_re "i") (re.++ (str.to_re "t") (re.++ (str.to_re "R") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re " ") (re.++ (re.++ (str.to_re "m") (re.++ (str.to_re "k") (re.++ (str.to_re "R") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "2013") (re.++ ((_ re.loop 11 11) (re.range "0" "9")) (re.++ (str.to_re "A") (re.++ (str.to_re "H") (re.++ (str.to_re "021") (str.to_re "\u{22}"))))))))))))))) (re.++ (str.to_re " ") (re.++ (str.to_re "m") (re.++ (str.to_re "y") (re.++ (str.to_re "D") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (str.to_re "a")))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)