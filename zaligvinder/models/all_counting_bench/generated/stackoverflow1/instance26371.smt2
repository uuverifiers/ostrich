;test regex \([A-Za-z]{4}\)-[0-9]{6}-[A-Za-z]{3}-[0-9]{3}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "(") (re.++ ((_ re.loop 4 4) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.++ (str.to_re ")") (re.++ (str.to_re "-") (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (re.++ (str.to_re "-") (re.++ ((_ re.loop 3 3) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.++ (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)