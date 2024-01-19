;test regex ^.* [aA][uU][tT][hH][eE][nN][tT][iI][cC][aA][tT][eE] [^\u{0a}]{100}\"\"\"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re " ") (re.++ (re.union (str.to_re "a") (str.to_re "A")) (re.++ (re.union (str.to_re "u") (str.to_re "U")) (re.++ (re.union (str.to_re "t") (str.to_re "T")) (re.++ (re.union (str.to_re "h") (str.to_re "H")) (re.++ (re.union (str.to_re "e") (str.to_re "E")) (re.++ (re.union (str.to_re "n") (str.to_re "N")) (re.++ (re.union (str.to_re "t") (str.to_re "T")) (re.++ (re.union (str.to_re "i") (str.to_re "I")) (re.++ (re.union (str.to_re "c") (str.to_re "C")) (re.++ (re.union (str.to_re "a") (str.to_re "A")) (re.++ (re.union (str.to_re "t") (str.to_re "T")) (re.++ (re.union (str.to_re "e") (str.to_re "E")) (re.++ (str.to_re " ") (re.++ ((_ re.loop 100 100) (re.diff re.allchar (str.to_re "\u{0a}"))) (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "\u{22}") (str.to_re "\u{22}"))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)