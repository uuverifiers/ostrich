;test regex string RegExPattern = @"^[KCMXSW][0-9]-[A-Z0-9]{4}[A-Z]$";
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "g") (re.++ (str.to_re " ") (re.++ (str.to_re "R") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "E") (re.++ (str.to_re "x") (re.++ (str.to_re "P") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "n") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re " ") (re.++ (str.to_re "@") (str.to_re "\u{22}")))))))))))))))))))))))) (re.++ (str.to_re "") (re.++ (re.union (str.to_re "K") (re.union (str.to_re "C") (re.union (str.to_re "M") (re.union (str.to_re "X") (re.union (str.to_re "S") (str.to_re "W")))))) (re.++ (re.range "0" "9") (re.++ (str.to_re "-") (re.++ ((_ re.loop 4 4) (re.union (re.range "A" "Z") (re.range "0" "9"))) (re.range "A" "Z"))))))) (re.++ (str.to_re "") (re.++ (str.to_re "\u{22}") (str.to_re ";"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)