;test regex (\d{3}.\d{2})  (.ABC or .XYZ MORE EXTENSIONS)
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (re.diff re.allchar (str.to_re "\n")) ((_ re.loop 2 2) (re.range "0" "9")))) (re.++ (str.to_re " ") (re.++ (str.to_re " ") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "A") (re.++ (str.to_re "B") (re.++ (str.to_re "C") (re.++ (str.to_re " ") (re.++ (str.to_re "o") (re.++ (str.to_re "r") (re.++ (str.to_re " ") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "X") (re.++ (str.to_re "Y") (re.++ (str.to_re "Z") (re.++ (str.to_re " ") (re.++ (str.to_re "M") (re.++ (str.to_re "O") (re.++ (str.to_re "R") (re.++ (str.to_re "E") (re.++ (str.to_re " ") (re.++ (str.to_re "E") (re.++ (str.to_re "X") (re.++ (str.to_re "T") (re.++ (str.to_re "E") (re.++ (str.to_re "N") (re.++ (str.to_re "S") (re.++ (str.to_re "I") (re.++ (str.to_re "O") (re.++ (str.to_re "N") (str.to_re "S")))))))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)