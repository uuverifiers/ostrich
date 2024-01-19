;test regex [A-HJ-NPR-TV-Y](2[1-9]|[3-9]\d|[1-8]\d\d|9[0-8]\d|99[0-8])[A-HJ-PR-Y]{3}
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.range "A" "H") (re.union (re.range "J" "N") (re.union (str.to_re "P") (re.union (re.range "R" "T") (re.range "V" "Y"))))) (re.++ (re.union (re.union (re.union (re.union (re.++ (str.to_re "2") (re.range "1" "9")) (re.++ (re.range "3" "9") (re.range "0" "9"))) (re.++ (re.range "1" "8") (re.++ (re.range "0" "9") (re.range "0" "9")))) (re.++ (str.to_re "9") (re.++ (re.range "0" "8") (re.range "0" "9")))) (re.++ (str.to_re "99") (re.range "0" "8"))) ((_ re.loop 3 3) (re.union (re.range "A" "H") (re.union (re.range "J" "P") (re.range "R" "Y"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)