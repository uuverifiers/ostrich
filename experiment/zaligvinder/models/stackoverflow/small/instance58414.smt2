;test regex string mySub = "${1}" + "1" + "$2";
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "g") (re.++ (str.to_re " ") (re.++ (str.to_re "m") (re.++ (str.to_re "y") (re.++ (str.to_re "S") (re.++ (str.to_re "u") (re.++ (str.to_re "b") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re " ") (str.to_re "\u{22}")))))))))))))))) (re.++ ((_ re.loop 1 1) (str.to_re "")) (re.++ (str.to_re "\u{22}") (re.++ (re.+ (str.to_re " ")) (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "1") (re.++ (str.to_re "\u{22}") (re.++ (re.+ (str.to_re " ")) (re.++ (str.to_re " ") (str.to_re "\u{22}"))))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "2") (re.++ (str.to_re "\u{22}") (str.to_re ";")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)