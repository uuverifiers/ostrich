;test regex echo "SRC='999'" | grep -o -E '[0-9]{3}'
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "e") (re.++ (str.to_re "c") (re.++ (str.to_re "h") (re.++ (str.to_re "o") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "S") (re.++ (str.to_re "R") (re.++ (str.to_re "C") (re.++ (str.to_re "=") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "999") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re "\u{22}") (str.to_re " "))))))))))))))) (re.++ (str.to_re " ") (re.++ (str.to_re "g") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (str.to_re "o") (re.++ (str.to_re " ") (re.++ (str.to_re "-") (re.++ (str.to_re "E") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{27}") (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{27}"))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)