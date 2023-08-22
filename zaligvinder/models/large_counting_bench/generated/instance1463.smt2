;test regex $text = "Dat foo 13.45 and $600 bar {70} and {8}";
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re "t") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "D") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re " ") (re.++ (str.to_re "f") (re.++ (str.to_re "o") (re.++ (str.to_re "o") (re.++ (str.to_re " ") (re.++ (str.to_re "13") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "45") (re.++ (str.to_re " ") (re.++ (str.to_re "a") (re.++ (str.to_re "n") (re.++ (str.to_re "d") (str.to_re " "))))))))))))))))))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "600") (re.++ (str.to_re " ") (re.++ (str.to_re "b") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.++ ((_ re.loop 70 70) (str.to_re " ")) (re.++ (str.to_re " ") (re.++ (str.to_re "a") (re.++ (str.to_re "n") (re.++ (str.to_re "d") (re.++ ((_ re.loop 8 8) (str.to_re " ")) (re.++ (str.to_re "\u{22}") (str.to_re ";")))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 200 (str.len X)))
(check-sat)
(get-model)