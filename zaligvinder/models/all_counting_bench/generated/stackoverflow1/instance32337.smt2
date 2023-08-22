;test regex /([A-Z]{4}) (AIRMET|SIGMET) (\w{1,3}) VALID (\d{6}\/\d{6}) ([A-Z]{4})-/
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "/") (re.++ ((_ re.loop 4 4) (re.range "A" "Z")) (re.++ (str.to_re " ") (re.++ (re.union (re.++ (str.to_re "A") (re.++ (str.to_re "I") (re.++ (str.to_re "R") (re.++ (str.to_re "M") (re.++ (str.to_re "E") (str.to_re "T")))))) (re.++ (str.to_re "S") (re.++ (str.to_re "I") (re.++ (str.to_re "G") (re.++ (str.to_re "M") (re.++ (str.to_re "E") (str.to_re "T"))))))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 1 3) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (re.++ (str.to_re " ") (re.++ (str.to_re "V") (re.++ (str.to_re "A") (re.++ (str.to_re "L") (re.++ (str.to_re "I") (re.++ (str.to_re "D") (re.++ (str.to_re " ") (re.++ (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (re.++ (str.to_re "/") ((_ re.loop 6 6) (re.range "0" "9")))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 4 4) (re.range "A" "Z")) (re.++ (str.to_re "-") (str.to_re "/"))))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)