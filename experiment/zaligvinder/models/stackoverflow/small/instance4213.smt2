;test regex SELECT REGEX_MATCH(PC_Rating,r'PG![0-9]{2}')
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "S") (re.++ (str.to_re "E") (re.++ (str.to_re "L") (re.++ (str.to_re "E") (re.++ (str.to_re "C") (re.++ (str.to_re "T") (re.++ (str.to_re " ") (re.++ (str.to_re "R") (re.++ (str.to_re "E") (re.++ (str.to_re "G") (re.++ (str.to_re "E") (re.++ (str.to_re "X") (re.++ (str.to_re "_") (re.++ (str.to_re "M") (re.++ (str.to_re "A") (re.++ (str.to_re "T") (re.++ (str.to_re "C") (re.++ (str.to_re "H") (re.++ (re.++ (str.to_re "P") (re.++ (str.to_re "C") (re.++ (str.to_re "_") (re.++ (str.to_re "R") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (str.to_re "g"))))))))) (re.++ (str.to_re ",") (re.++ (str.to_re "r") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "P") (re.++ (str.to_re "G") (re.++ (str.to_re "!") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{27}")))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)