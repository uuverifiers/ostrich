;test regex grep -R --regexp="^[13][a-km-zA-HJ-NP-Z1-9]{25,34}$"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "g") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (str.to_re "R") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (str.to_re "-") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re "p") (re.++ (str.to_re "=") (str.to_re "\u{22}")))))))))))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "13") ((_ re.loop 25 34) (re.union (re.range "a" "k") (re.union (re.range "m" "z") (re.union (re.range "A" "H") (re.union (re.range "J" "N") (re.union (re.range "P" "Z") (re.range "1" "9")))))))))) (re.++ (str.to_re "") (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)