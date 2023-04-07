;test regex [l][i][b][r][a][r][y][_]\d{0,5} #digit from 0 to 99999
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "l") (re.++ (str.to_re "i") (re.++ (str.to_re "b") (re.++ (str.to_re "r") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.++ (str.to_re "y") (re.++ (str.to_re "_") (re.++ ((_ re.loop 0 5) (re.range "0" "9")) (re.++ (str.to_re " ") (re.++ (str.to_re "#") (re.++ (str.to_re "d") (re.++ (str.to_re "i") (re.++ (str.to_re "g") (re.++ (str.to_re "i") (re.++ (str.to_re "t") (re.++ (str.to_re " ") (re.++ (str.to_re "f") (re.++ (str.to_re "r") (re.++ (str.to_re "o") (re.++ (str.to_re "m") (re.++ (str.to_re " ") (re.++ (str.to_re "0") (re.++ (str.to_re " ") (re.++ (str.to_re "t") (re.++ (str.to_re "o") (re.++ (str.to_re " ") (str.to_re "99999"))))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)