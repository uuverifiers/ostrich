;test regex \A<meta name=foo content=([+\/0-9A-Za-z]{84}) \/>\z
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "A") (re.++ (str.to_re "<") (re.++ (str.to_re "m") (re.++ (str.to_re "e") (re.++ (str.to_re "t") (re.++ (str.to_re "a") (re.++ (str.to_re " ") (re.++ (str.to_re "n") (re.++ (str.to_re "a") (re.++ (str.to_re "m") (re.++ (str.to_re "e") (re.++ (str.to_re "=") (re.++ (str.to_re "f") (re.++ (str.to_re "o") (re.++ (str.to_re "o") (re.++ (str.to_re " ") (re.++ (str.to_re "c") (re.++ (str.to_re "o") (re.++ (str.to_re "n") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "n") (re.++ (str.to_re "t") (re.++ (str.to_re "=") (re.++ ((_ re.loop 84 84) (re.union (str.to_re "+") (re.union (str.to_re "/") (re.union (re.range "0" "9") (re.union (re.range "A" "Z") (re.range "a" "z")))))) (re.++ (str.to_re " ") (re.++ (str.to_re "/") (re.++ (str.to_re ">") (str.to_re "z")))))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 200 (str.len X)))
(check-sat)
(get-model)