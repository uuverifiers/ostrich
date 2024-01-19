;test regex myId REGEXP '^[A-Z]{3}/d{4}'
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "m") (re.++ (str.to_re "y") (re.++ (str.to_re "I") (re.++ (str.to_re "d") (re.++ (str.to_re " ") (re.++ (str.to_re "R") (re.++ (str.to_re "E") (re.++ (str.to_re "G") (re.++ (str.to_re "E") (re.++ (str.to_re "X") (re.++ (str.to_re "P") (re.++ (str.to_re " ") (str.to_re "\u{27}"))))))))))))) (re.++ (str.to_re "") (re.++ ((_ re.loop 3 3) (re.range "A" "Z")) (re.++ (str.to_re "/") (re.++ ((_ re.loop 4 4) (str.to_re "d")) (str.to_re "\u{27}"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)