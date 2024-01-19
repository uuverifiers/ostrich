;test regex (CORP ACT OPTION NO.*?)(?:\r|\n|\r\n){2}
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "C") (re.++ (str.to_re "O") (re.++ (str.to_re "R") (re.++ (str.to_re "P") (re.++ (str.to_re " ") (re.++ (str.to_re "A") (re.++ (str.to_re "C") (re.++ (str.to_re "T") (re.++ (str.to_re " ") (re.++ (str.to_re "O") (re.++ (str.to_re "P") (re.++ (str.to_re "T") (re.++ (str.to_re "I") (re.++ (str.to_re "O") (re.++ (str.to_re "N") (re.++ (str.to_re " ") (re.++ (str.to_re "N") (re.++ (str.to_re "O") (re.* (re.diff re.allchar (str.to_re "\n"))))))))))))))))))))) ((_ re.loop 2 2) (re.union (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}")) (re.++ (str.to_re "\u{0d}") (str.to_re "\u{0a}")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)