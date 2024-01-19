;test regex Days  and months are  1 or 2 digits
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "D") (re.++ (str.to_re "a") (re.++ (str.to_re "y") (re.++ (str.to_re "s") (re.++ (str.to_re " ") (re.++ (str.to_re " ") (re.++ (str.to_re "a") (re.++ (str.to_re "n") (re.++ (str.to_re "d") (re.++ (str.to_re " ") (re.++ (str.to_re "m") (re.++ (str.to_re "o") (re.++ (str.to_re "n") (re.++ (str.to_re "t") (re.++ (str.to_re "h") (re.++ (str.to_re "s") (re.++ (str.to_re " ") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re " ") (re.++ (str.to_re " ") (re.++ (str.to_re "1") (re.++ (str.to_re " ") (re.++ (str.to_re "o") (re.++ (str.to_re "r") (re.++ (str.to_re " ") (re.++ (str.to_re "2") (re.++ (str.to_re " ") (re.++ (str.to_re "d") (re.++ (str.to_re "i") (re.++ (str.to_re "g") (re.++ (str.to_re "i") (re.++ (str.to_re "t") (str.to_re "s")))))))))))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)