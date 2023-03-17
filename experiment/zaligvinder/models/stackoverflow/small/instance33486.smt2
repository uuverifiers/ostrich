;test regex ([A-Z0-9]{9}) Fixed Value
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 9 9) (re.union (re.range "A" "Z") (re.range "0" "9"))) (re.++ (str.to_re " ") (re.++ (str.to_re "F") (re.++ (str.to_re "i") (re.++ (str.to_re "x") (re.++ (str.to_re "e") (re.++ (str.to_re "d") (re.++ (str.to_re " ") (re.++ (str.to_re "V") (re.++ (str.to_re "a") (re.++ (str.to_re "l") (re.++ (str.to_re "u") (str.to_re "e")))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)