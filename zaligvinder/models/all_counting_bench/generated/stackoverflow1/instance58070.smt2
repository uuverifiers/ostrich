;test regex aaa( |\n)bbbb( |\n)cc( |\n)( |\n){0,1}(.|\n)*xx( |\n)yyy( |\n)Z
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "a") (re.++ (str.to_re "a") (re.++ (str.to_re "a") (re.++ (re.union (str.to_re " ") (str.to_re "\u{0a}")) (re.++ (str.to_re "b") (re.++ (str.to_re "b") (re.++ (str.to_re "b") (re.++ (str.to_re "b") (re.++ (re.union (str.to_re " ") (str.to_re "\u{0a}")) (re.++ (str.to_re "c") (re.++ (str.to_re "c") (re.++ (re.union (str.to_re " ") (str.to_re "\u{0a}")) (re.++ ((_ re.loop 0 1) (re.union (str.to_re " ") (str.to_re "\u{0a}"))) (re.++ (re.* (re.union (re.diff re.allchar (str.to_re "\n")) (str.to_re "\u{0a}"))) (re.++ (str.to_re "x") (re.++ (str.to_re "x") (re.++ (re.union (str.to_re " ") (str.to_re "\u{0a}")) (re.++ (str.to_re "y") (re.++ (str.to_re "y") (re.++ (str.to_re "y") (re.++ (re.union (str.to_re " ") (str.to_re "\u{0a}")) (str.to_re "Z"))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)