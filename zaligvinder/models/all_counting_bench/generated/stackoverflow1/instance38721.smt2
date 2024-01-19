;test regex String.split("((\\n\\r)|(\\r\\n)){2}|(\\r){2}|(\\n){2}");
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "S") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "g") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "s") (re.++ (str.to_re "p") (re.++ (str.to_re "l") (re.++ (str.to_re "i") (re.++ (str.to_re "t") (re.++ (re.union (re.union (re.++ (str.to_re "\u{22}") ((_ re.loop 2 2) (re.union (re.++ (str.to_re "\\") (re.++ (str.to_re "n") (re.++ (str.to_re "\\") (str.to_re "r")))) (re.++ (str.to_re "\\") (re.++ (str.to_re "r") (re.++ (str.to_re "\\") (str.to_re "n"))))))) ((_ re.loop 2 2) (re.++ (str.to_re "\\") (str.to_re "r")))) (re.++ ((_ re.loop 2 2) (re.++ (str.to_re "\\") (str.to_re "n"))) (str.to_re "\u{22}"))) (str.to_re ";"))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)