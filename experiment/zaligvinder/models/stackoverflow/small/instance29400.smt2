;test regex var pattern = /(0\d{1}|1[0-2])\/([0-2]\d{1}|3[0-1])\/(19|20)\d{2}/
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "v") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.++ (str.to_re " ") (re.++ (str.to_re "p") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "n") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re " ") (re.++ (str.to_re "/") (re.++ (re.union (re.++ (str.to_re "0") ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ (str.to_re "1") (re.range "0" "2"))) (re.++ (str.to_re "/") (re.++ (re.union (re.++ (re.range "0" "2") ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ (str.to_re "3") (re.range "0" "1"))) (re.++ (str.to_re "/") (re.++ (re.union (str.to_re "19") (str.to_re "20")) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "/"))))))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)