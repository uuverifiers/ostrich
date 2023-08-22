;test regex 12 hour format hh:MM:ss AM|PM 
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "12") (re.++ (str.to_re " ") (re.++ (str.to_re "h") (re.++ (str.to_re "o") (re.++ (str.to_re "u") (re.++ (str.to_re "r") (re.++ (str.to_re " ") (re.++ (str.to_re "f") (re.++ (str.to_re "o") (re.++ (str.to_re "r") (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re " ") (re.++ (str.to_re "h") (re.++ (str.to_re "h") (re.++ (str.to_re ":") (re.++ (str.to_re "M") (re.++ (str.to_re "M") (re.++ (str.to_re ":") (re.++ (str.to_re "s") (re.++ (str.to_re "s") (re.++ (str.to_re " ") (re.++ (str.to_re "A") (str.to_re "M"))))))))))))))))))))))))) (re.++ (str.to_re "P") (re.++ (str.to_re "M") (str.to_re " "))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)