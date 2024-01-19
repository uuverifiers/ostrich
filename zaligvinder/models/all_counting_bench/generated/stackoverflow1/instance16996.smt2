;test regex AND REGEXP_LIKE(auto.license, '^[A-Z]{2}')
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "A") (re.++ (str.to_re "N") (re.++ (str.to_re "D") (re.++ (str.to_re " ") (re.++ (str.to_re "R") (re.++ (str.to_re "E") (re.++ (str.to_re "G") (re.++ (str.to_re "E") (re.++ (str.to_re "X") (re.++ (str.to_re "P") (re.++ (str.to_re "_") (re.++ (str.to_re "L") (re.++ (str.to_re "I") (re.++ (str.to_re "K") (re.++ (str.to_re "E") (re.++ (re.++ (re.++ (str.to_re "a") (re.++ (str.to_re "u") (re.++ (str.to_re "t") (re.++ (str.to_re "o") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "l") (re.++ (str.to_re "i") (re.++ (str.to_re "c") (re.++ (str.to_re "e") (re.++ (str.to_re "n") (re.++ (str.to_re "s") (str.to_re "e")))))))))))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (str.to_re "\u{27}")))) (re.++ (str.to_re "") (re.++ ((_ re.loop 2 2) (re.range "A" "Z")) (str.to_re "\u{27}")))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)