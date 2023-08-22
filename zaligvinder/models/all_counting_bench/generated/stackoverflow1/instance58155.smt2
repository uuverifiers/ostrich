;test regex /^(1[0-2]|0[1-9])\/(3[01]|[12][0-9]|0[1-9])\/[0-9]{4} ([0-2][0-9]\:[0-5][0-9]) (AM|PM)$/
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "/") (re.++ (str.to_re "") (re.++ (re.union (re.++ (str.to_re "1") (re.range "0" "2")) (re.++ (str.to_re "0") (re.range "1" "9"))) (re.++ (str.to_re "/") (re.++ (re.union (re.union (re.++ (str.to_re "3") (str.to_re "01")) (re.++ (str.to_re "12") (re.range "0" "9"))) (re.++ (str.to_re "0") (re.range "1" "9"))) (re.++ (str.to_re "/") (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (str.to_re " ") (re.++ (re.++ (re.range "0" "2") (re.++ (re.range "0" "9") (re.++ (str.to_re ":") (re.++ (re.range "0" "5") (re.range "0" "9"))))) (re.++ (str.to_re " ") (re.union (re.++ (str.to_re "A") (str.to_re "M")) (re.++ (str.to_re "P") (str.to_re "M"))))))))))))) (re.++ (str.to_re "") (str.to_re "/")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)