;test regex [A-Za-z0-9]+_Enrollment_(19|20)\d\d(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[01])_[0-9]{4}\.xml
(declare-const X String)
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9")))) (re.++ (str.to_re "_") (re.++ (str.to_re "E") (re.++ (str.to_re "n") (re.++ (str.to_re "r") (re.++ (str.to_re "o") (re.++ (str.to_re "l") (re.++ (str.to_re "l") (re.++ (str.to_re "m") (re.++ (str.to_re "e") (re.++ (str.to_re "n") (re.++ (str.to_re "t") (re.++ (str.to_re "_") (re.++ (re.union (str.to_re "19") (str.to_re "20")) (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (str.to_re "012"))) (re.++ (re.union (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "12") (re.range "0" "9"))) (re.++ (str.to_re "3") (str.to_re "01"))) (re.++ (str.to_re "_") (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (str.to_re ".") (re.++ (str.to_re "x") (re.++ (str.to_re "m") (str.to_re "l"))))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)