;test regex Mozilla\/5.0 \(iP ([\d]{0,3}[\.]{1}){3}30\)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "M") (re.++ (str.to_re "o") (re.++ (str.to_re "z") (re.++ (str.to_re "i") (re.++ (str.to_re "l") (re.++ (str.to_re "l") (re.++ (str.to_re "a") (re.++ (str.to_re "/") (re.++ (str.to_re "5") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "0") (re.++ (str.to_re " ") (re.++ (str.to_re "(") (re.++ (str.to_re "i") (re.++ (str.to_re "P") (re.++ (str.to_re " ") (re.++ ((_ re.loop 3 3) (re.++ ((_ re.loop 0 3) (re.range "0" "9")) ((_ re.loop 1 1) (str.to_re ".")))) (re.++ (str.to_re "30") (str.to_re ")")))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)