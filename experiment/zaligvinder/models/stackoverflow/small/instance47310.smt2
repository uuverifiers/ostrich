;test regex ^b\d{3}cv\d{2}_release\.ext$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "b") (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (str.to_re "c") (re.++ (str.to_re "v") (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (str.to_re "_") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (re.++ (str.to_re "a") (re.++ (str.to_re "s") (re.++ (str.to_re "e") (re.++ (str.to_re ".") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (str.to_re "t")))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)