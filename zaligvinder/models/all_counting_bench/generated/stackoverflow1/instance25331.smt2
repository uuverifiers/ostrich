;test regex egrep "p\.[A-Z][a-z]{1,}[0-9]{1,}[A-Z][a-z]{1,}" file1
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "e") (re.++ (str.to_re "g") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "p") (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "p") (re.++ (str.to_re ".") (re.++ (re.range "A" "Z") (re.++ (re.++ (re.* (re.range "a" "z")) ((_ re.loop 1 1) (re.range "a" "z"))) (re.++ (re.++ (re.* (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ (re.range "A" "Z") (re.++ (re.++ (re.* (re.range "a" "z")) ((_ re.loop 1 1) (re.range "a" "z"))) (re.++ (str.to_re "\u{22}") (re.++ (str.to_re " ") (re.++ (str.to_re "f") (re.++ (str.to_re "i") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (str.to_re "1")))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)