;test regex 'WHERE Answer.value NOT REGEXP "[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}"'
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "W") (re.++ (str.to_re "H") (re.++ (str.to_re "E") (re.++ (str.to_re "R") (re.++ (str.to_re "E") (re.++ (str.to_re " ") (re.++ (str.to_re "A") (re.++ (str.to_re "n") (re.++ (str.to_re "s") (re.++ (str.to_re "w") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "v") (re.++ (str.to_re "a") (re.++ (str.to_re "l") (re.++ (str.to_re "u") (re.++ (str.to_re "e") (re.++ (str.to_re " ") (re.++ (str.to_re "N") (re.++ (str.to_re "O") (re.++ (str.to_re "T") (re.++ (str.to_re " ") (re.++ (str.to_re "R") (re.++ (str.to_re "E") (re.++ (str.to_re "G") (re.++ (str.to_re "E") (re.++ (str.to_re "X") (re.++ (str.to_re "P") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ ((_ re.loop 8 8) (re.union (re.range "a" "f") (re.union (re.range "A" "F") (re.range "0" "9")))) (re.++ (str.to_re "-") (re.++ ((_ re.loop 4 4) (re.union (re.range "a" "f") (re.union (re.range "A" "F") (re.range "0" "9")))) (re.++ (str.to_re "-") (re.++ ((_ re.loop 4 4) (re.union (re.range "a" "f") (re.union (re.range "A" "F") (re.range "0" "9")))) (re.++ (str.to_re "-") (re.++ ((_ re.loop 4 4) (re.union (re.range "a" "f") (re.union (re.range "A" "F") (re.range "0" "9")))) (re.++ (str.to_re "-") (re.++ ((_ re.loop 12 12) (re.union (re.range "a" "f") (re.union (re.range "A" "F") (re.range "0" "9")))) (re.++ (str.to_re "\u{22}") (str.to_re "\u{27}")))))))))))))))))))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)