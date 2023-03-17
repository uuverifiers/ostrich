;test regex Dim reg As New Regex("\d{3}\D{0,1}\d{2}\D{0,1}\d{4,}")
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "D") (re.++ (str.to_re "i") (re.++ (str.to_re "m") (re.++ (str.to_re " ") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re " ") (re.++ (str.to_re "A") (re.++ (str.to_re "s") (re.++ (str.to_re " ") (re.++ (str.to_re "N") (re.++ (str.to_re "e") (re.++ (str.to_re "w") (re.++ (str.to_re " ") (re.++ (str.to_re "R") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re "\u{22}") (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ ((_ re.loop 0 1) (re.diff re.allchar (re.range "0" "9"))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ ((_ re.loop 0 1) (re.diff re.allchar (re.range "0" "9"))) (re.++ (re.++ (re.* (re.range "0" "9")) ((_ re.loop 4 4) (re.range "0" "9"))) (str.to_re "\u{22}")))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)