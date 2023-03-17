;test regex TestRegExp.exe ^a\d{5}$ a12345
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "T") (re.++ (str.to_re "e") (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "R") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "E") (re.++ (str.to_re "x") (re.++ (str.to_re "p") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re "e") (str.to_re " "))))))))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "a") ((_ re.loop 5 5) (re.range "0" "9"))))) (re.++ (str.to_re "") (re.++ (str.to_re " ") (re.++ (str.to_re "a") (str.to_re "12345")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)