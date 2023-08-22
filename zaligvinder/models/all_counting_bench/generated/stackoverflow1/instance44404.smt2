;test regex ls * | egrep "DLERMS[0-9]{4}170816[0-9]{10}.csv.gz"
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "l") (re.++ (str.to_re "s") (re.++ (re.* (str.to_re " ")) (str.to_re " ")))) (re.++ (str.to_re " ") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "D") (re.++ (str.to_re "L") (re.++ (str.to_re "E") (re.++ (str.to_re "R") (re.++ (str.to_re "M") (re.++ (str.to_re "S") (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (str.to_re "170816") (re.++ ((_ re.loop 10 10) (re.range "0" "9")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "c") (re.++ (str.to_re "s") (re.++ (str.to_re "v") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "g") (re.++ (str.to_re "z") (str.to_re "\u{22}"))))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)