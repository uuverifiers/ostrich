;test regex a{3,6}  #you want between 3 and 6 repeats of a
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 3 6) (str.to_re "a")) (re.++ (str.to_re " ") (re.++ (str.to_re " ") (re.++ (str.to_re "#") (re.++ (str.to_re "y") (re.++ (str.to_re "o") (re.++ (str.to_re "u") (re.++ (str.to_re " ") (re.++ (str.to_re "w") (re.++ (str.to_re "a") (re.++ (str.to_re "n") (re.++ (str.to_re "t") (re.++ (str.to_re " ") (re.++ (str.to_re "b") (re.++ (str.to_re "e") (re.++ (str.to_re "t") (re.++ (str.to_re "w") (re.++ (str.to_re "e") (re.++ (str.to_re "e") (re.++ (str.to_re "n") (re.++ (str.to_re " ") (re.++ (str.to_re "3") (re.++ (str.to_re " ") (re.++ (str.to_re "a") (re.++ (str.to_re "n") (re.++ (str.to_re "d") (re.++ (str.to_re " ") (re.++ (str.to_re "6") (re.++ (str.to_re " ") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (str.to_re "e") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "s") (re.++ (str.to_re " ") (re.++ (str.to_re "o") (re.++ (str.to_re "f") (re.++ (str.to_re " ") (str.to_re "a")))))))))))))))))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)