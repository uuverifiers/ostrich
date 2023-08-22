;test regex egrep '^[0-9]{0,}X(\^[0-9]{1,}){0,1}$'  filename
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (str.to_re " ") (str.to_re "\u{27}"))))))) (re.++ (str.to_re "") (re.++ (re.++ (re.* (re.range "0" "9")) ((_ re.loop 0 0) (re.range "0" "9"))) (re.++ (str.to_re "X") ((_ re.loop 0 1) (re.++ (str.to_re "^") (re.++ (re.* (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9"))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "\u{27}") (re.++ (str.to_re " ") (re.++ (str.to_re " ") (re.++ (str.to_re "f") (re.++ (str.to_re "i") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (re.++ (str.to_re "n") (re.++ (str.to_re "a") (re.++ (str.to_re "m") (str.to_re "e")))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)