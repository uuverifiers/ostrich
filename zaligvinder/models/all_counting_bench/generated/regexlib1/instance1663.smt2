;test regex for mobile:^[0][1-9]{1}[0-9]{9}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "f") (re.++ (str.to_re "o") (re.++ (str.to_re "r") (re.++ (str.to_re " ") (re.++ (str.to_re "m") (re.++ (str.to_re "o") (re.++ (str.to_re "b") (re.++ (str.to_re "i") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (str.to_re ":"))))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "0") (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 9 9) (re.range "0" "9")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)