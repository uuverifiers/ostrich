;test regex sed -i '/myVariable/s/"\([^"]*\)"/"${1}"/' /file
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "s") (re.++ (str.to_re "e") (re.++ (str.to_re "d") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (str.to_re "i") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "/") (re.++ (str.to_re "m") (re.++ (str.to_re "y") (re.++ (str.to_re "V") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "a") (re.++ (str.to_re "b") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (re.++ (str.to_re "/") (re.++ (str.to_re "s") (re.++ (str.to_re "/") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "(") (re.++ (re.* (re.diff re.allchar (str.to_re "\u{22}"))) (re.++ (str.to_re ")") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "/") (str.to_re "\u{22}"))))))))))))))))))))))))))))) (re.++ ((_ re.loop 1 1) (str.to_re "")) (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "/") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re " ") (re.++ (str.to_re "/") (re.++ (str.to_re "f") (re.++ (str.to_re "i") (re.++ (str.to_re "l") (str.to_re "e")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)