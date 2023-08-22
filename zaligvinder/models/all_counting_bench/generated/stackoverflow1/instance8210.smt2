;test regex ^-(.)=((\d{1,3})(F|f))*((\d{1,2})(I|i))*((\d{1,2})(/(2|4|8|16|32|64))*)*$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "-") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "=") (re.++ (re.* (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.union (str.to_re "F") (str.to_re "f")))) (re.++ (re.* (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.union (str.to_re "I") (str.to_re "i")))) (re.* (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.* (re.++ (str.to_re "/") (re.union (re.union (re.union (re.union (re.union (str.to_re "2") (str.to_re "4")) (str.to_re "8")) (str.to_re "16")) (str.to_re "32")) (str.to_re "64")))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)