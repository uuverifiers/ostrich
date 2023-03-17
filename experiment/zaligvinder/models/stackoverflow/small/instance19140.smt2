;test regex The {0} fox jumped over the {1} bridge
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "T") (re.++ (str.to_re "h") (re.++ (str.to_re "e") (re.++ ((_ re.loop 0 0) (str.to_re " ")) (re.++ (str.to_re " ") (re.++ (str.to_re "f") (re.++ (str.to_re "o") (re.++ (str.to_re "x") (re.++ (str.to_re " ") (re.++ (str.to_re "j") (re.++ (str.to_re "u") (re.++ (str.to_re "m") (re.++ (str.to_re "p") (re.++ (str.to_re "e") (re.++ (str.to_re "d") (re.++ (str.to_re " ") (re.++ (str.to_re "o") (re.++ (str.to_re "v") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re " ") (re.++ (str.to_re "t") (re.++ (str.to_re "h") (re.++ (str.to_re "e") (re.++ ((_ re.loop 1 1) (str.to_re " ")) (re.++ (str.to_re " ") (re.++ (str.to_re "b") (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "d") (re.++ (str.to_re "g") (str.to_re "e"))))))))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)