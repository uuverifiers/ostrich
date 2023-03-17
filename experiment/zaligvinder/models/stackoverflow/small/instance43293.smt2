;test regex UK[A-Za-z]{10}|DE[A-Za-z]{20}|PL[A-Za-z]{7}
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (str.to_re "U") (re.++ (str.to_re "K") ((_ re.loop 10 10) (re.union (re.range "A" "Z") (re.range "a" "z"))))) (re.++ (str.to_re "D") (re.++ (str.to_re "E") ((_ re.loop 20 20) (re.union (re.range "A" "Z") (re.range "a" "z")))))) (re.++ (str.to_re "P") (re.++ (str.to_re "L") ((_ re.loop 7 7) (re.union (re.range "A" "Z") (re.range "a" "z"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)