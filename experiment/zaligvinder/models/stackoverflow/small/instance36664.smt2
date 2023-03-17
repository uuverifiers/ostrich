;test regex command | grep -zoP "\-{5}BEGIN*(\n|.)*REQUEST\-{5}"
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "c") (re.++ (str.to_re "o") (re.++ (str.to_re "m") (re.++ (str.to_re "m") (re.++ (str.to_re "a") (re.++ (str.to_re "n") (re.++ (str.to_re "d") (str.to_re " ")))))))) (re.++ (str.to_re " ") (re.++ (str.to_re "g") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (str.to_re "z") (re.++ (str.to_re "o") (re.++ (str.to_re "P") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ ((_ re.loop 5 5) (str.to_re "-")) (re.++ (str.to_re "B") (re.++ (str.to_re "E") (re.++ (str.to_re "G") (re.++ (str.to_re "I") (re.++ (re.* (str.to_re "N")) (re.++ (re.* (re.union (str.to_re "\u{0a}") (re.diff re.allchar (str.to_re "\n")))) (re.++ (str.to_re "R") (re.++ (str.to_re "E") (re.++ (str.to_re "Q") (re.++ (str.to_re "U") (re.++ (str.to_re "E") (re.++ (str.to_re "S") (re.++ (str.to_re "T") (re.++ ((_ re.loop 5 5) (str.to_re "-")) (str.to_re "\u{22}")))))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)