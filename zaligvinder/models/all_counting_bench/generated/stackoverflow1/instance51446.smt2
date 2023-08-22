;test regex \*\d{4}\*\d{1}\*[ABCEFGHJKLMPRV]{1}(\*)\d+\,M-\d{2},R-\d{5}
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "*") (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (str.to_re "*") (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (re.++ (str.to_re "*") (re.++ ((_ re.loop 1 1) (re.union (str.to_re "A") (re.union (str.to_re "B") (re.union (str.to_re "C") (re.union (str.to_re "E") (re.union (str.to_re "F") (re.union (str.to_re "G") (re.union (str.to_re "H") (re.union (str.to_re "J") (re.union (str.to_re "K") (re.union (str.to_re "L") (re.union (str.to_re "M") (re.union (str.to_re "P") (re.union (str.to_re "R") (str.to_re "V"))))))))))))))) (re.++ (str.to_re "*") (re.++ (re.+ (re.range "0" "9")) (re.++ (str.to_re ",") (re.++ (str.to_re "M") (re.++ (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9"))))))))))))) (re.++ (str.to_re ",") (re.++ (str.to_re "R") (re.++ (str.to_re "-") ((_ re.loop 5 5) (re.range "0" "9"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)