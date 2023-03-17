;test regex regex = "(?:2\d|[3-9]\d|[1-8]\d{2}|9[0-8]\d|99[0-8])"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ (re.union (re.union (re.union (re.union (re.++ (str.to_re "2") (re.range "0" "9")) (re.++ (re.range "3" "9") (re.range "0" "9"))) (re.++ (re.range "1" "8") ((_ re.loop 2 2) (re.range "0" "9")))) (re.++ (str.to_re "9") (re.++ (re.range "0" "8") (re.range "0" "9")))) (re.++ (str.to_re "99") (re.range "0" "8"))) (str.to_re "\u{22}")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)