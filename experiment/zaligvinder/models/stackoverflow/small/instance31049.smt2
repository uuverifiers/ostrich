;test regex WHERE colA NOT LIKE '2[6-9]{2}'
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "W") (re.++ (str.to_re "H") (re.++ (str.to_re "E") (re.++ (str.to_re "R") (re.++ (str.to_re "E") (re.++ (str.to_re " ") (re.++ (str.to_re "c") (re.++ (str.to_re "o") (re.++ (str.to_re "l") (re.++ (str.to_re "A") (re.++ (str.to_re " ") (re.++ (str.to_re "N") (re.++ (str.to_re "O") (re.++ (str.to_re "T") (re.++ (str.to_re " ") (re.++ (str.to_re "L") (re.++ (str.to_re "I") (re.++ (str.to_re "K") (re.++ (str.to_re "E") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "2") (re.++ ((_ re.loop 2 2) (re.range "6" "9")) (str.to_re "\u{27}"))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)