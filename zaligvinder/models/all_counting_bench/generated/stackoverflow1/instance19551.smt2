;test regex @"(N[0-9][EHPULMAVRYGBWK123670]{4}[N]{1}PF[0]{1}[0-9]{1})";
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "@") (re.++ (str.to_re "\u{22}") (re.++ (re.++ (str.to_re "N") (re.++ (re.range "0" "9") (re.++ ((_ re.loop 4 4) (re.union (str.to_re "E") (re.union (str.to_re "H") (re.union (str.to_re "P") (re.union (str.to_re "U") (re.union (str.to_re "L") (re.union (str.to_re "M") (re.union (str.to_re "A") (re.union (str.to_re "V") (re.union (str.to_re "R") (re.union (str.to_re "Y") (re.union (str.to_re "G") (re.union (str.to_re "B") (re.union (str.to_re "W") (re.union (str.to_re "K") (str.to_re "123670")))))))))))))))) (re.++ ((_ re.loop 1 1) (str.to_re "N")) (re.++ (str.to_re "P") (re.++ (str.to_re "F") (re.++ ((_ re.loop 1 1) (str.to_re "0")) ((_ re.loop 1 1) (re.range "0" "9"))))))))) (re.++ (str.to_re "\u{22}") (str.to_re ";")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)