;test regex (<value pattern>){10}(\r\n|\r|\n|$)
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 10 10) (re.++ (str.to_re "<") (re.++ (str.to_re "v") (re.++ (str.to_re "a") (re.++ (str.to_re "l") (re.++ (str.to_re "u") (re.++ (str.to_re "e") (re.++ (str.to_re " ") (re.++ (str.to_re "p") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "n") (str.to_re ">")))))))))))))))) (re.union (re.union (re.union (re.++ (str.to_re "\u{0d}") (str.to_re "\u{0a}")) (str.to_re "\u{0d}")) (str.to_re "\u{0a}")) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)