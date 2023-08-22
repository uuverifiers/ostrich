;test regex .. figure:: (.*?)(\R{2}[ ]{3}.*\R)
(declare-const X String)
(assert (str.in_re X (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re " ") (re.++ (str.to_re "f") (re.++ (str.to_re "i") (re.++ (str.to_re "g") (re.++ (str.to_re "u") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re ":") (re.++ (str.to_re ":") (re.++ (str.to_re " ") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 2 2) (str.to_re "R")) (re.++ ((_ re.loop 3 3) (str.to_re " ")) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (str.to_re "R")))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)