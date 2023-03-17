;test regex (\d{2} (?:January|February|...|December) \d{4})
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re " ") (re.++ (re.union (re.union (re.union (re.++ (str.to_re "J") (re.++ (str.to_re "a") (re.++ (str.to_re "n") (re.++ (str.to_re "u") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (str.to_re "y"))))))) (re.++ (str.to_re "F") (re.++ (str.to_re "e") (re.++ (str.to_re "b") (re.++ (str.to_re "r") (re.++ (str.to_re "u") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (str.to_re "y"))))))))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.diff re.allchar (str.to_re "\n"))))) (re.++ (str.to_re "D") (re.++ (str.to_re "e") (re.++ (str.to_re "c") (re.++ (str.to_re "e") (re.++ (str.to_re "m") (re.++ (str.to_re "b") (re.++ (str.to_re "e") (str.to_re "r"))))))))) (re.++ (str.to_re " ") ((_ re.loop 4 4) (re.range "0" "9"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)