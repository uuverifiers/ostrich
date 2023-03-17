;test regex egrep "^[0-9]+;{1}[^; ][a-zA-Z ]+" SALESORDERLIST
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (str.to_re " ") (str.to_re "\u{22}"))))))) (re.++ (str.to_re "") (re.++ (re.+ (re.range "0" "9")) (re.++ ((_ re.loop 1 1) (str.to_re ";")) (re.++ (re.inter (re.diff re.allchar (str.to_re ";")) (re.diff re.allchar (str.to_re " "))) (re.++ (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (str.to_re " ")))) (re.++ (str.to_re "\u{22}") (re.++ (str.to_re " ") (re.++ (str.to_re "S") (re.++ (str.to_re "A") (re.++ (str.to_re "L") (re.++ (str.to_re "E") (re.++ (str.to_re "S") (re.++ (str.to_re "O") (re.++ (str.to_re "R") (re.++ (str.to_re "D") (re.++ (str.to_re "E") (re.++ (str.to_re "R") (re.++ (str.to_re "L") (re.++ (str.to_re "I") (re.++ (str.to_re "S") (str.to_re "T"))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)