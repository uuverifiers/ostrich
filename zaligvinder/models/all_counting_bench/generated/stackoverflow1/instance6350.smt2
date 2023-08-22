;test regex FINDSTR /r .*Shutdown.*{5} file.txt
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "F") (re.++ (str.to_re "I") (re.++ (str.to_re "N") (re.++ (str.to_re "D") (re.++ (str.to_re "S") (re.++ (str.to_re "T") (re.++ (str.to_re "R") (re.++ (str.to_re " ") (re.++ (str.to_re "/") (re.++ (str.to_re "r") (re.++ (str.to_re " ") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "S") (re.++ (str.to_re "h") (re.++ (str.to_re "u") (re.++ (str.to_re "t") (re.++ (str.to_re "d") (re.++ (str.to_re "o") (re.++ (str.to_re "w") (re.++ (str.to_re "n") (re.++ ((_ re.loop 5 5) (re.* (re.diff re.allchar (str.to_re "\n")))) (re.++ (str.to_re " ") (re.++ (str.to_re "f") (re.++ (str.to_re "i") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "t") (re.++ (str.to_re "x") (str.to_re "t"))))))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)