;test regex [0-9]{4}[A-Z]{2}[a-z]{2}_filename_\d{8}_[0-9]{6}\.csv
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ ((_ re.loop 2 2) (re.range "A" "Z")) (re.++ ((_ re.loop 2 2) (re.range "a" "z")) (re.++ (str.to_re "_") (re.++ (str.to_re "f") (re.++ (str.to_re "i") (re.++ (str.to_re "l") (re.++ (str.to_re "e") (re.++ (str.to_re "n") (re.++ (str.to_re "a") (re.++ (str.to_re "m") (re.++ (str.to_re "e") (re.++ (str.to_re "_") (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (re.++ (str.to_re "_") (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (re.++ (str.to_re ".") (re.++ (str.to_re "c") (re.++ (str.to_re "s") (str.to_re "v"))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)