;test regex (?:(?:2[0-5][0-5]|1\d\d|[1-9]\d|\d)\.){3}(?:2[0-5][0-5]|1\d\d|[1-9]\d|\d)\s(5\d{3})
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 3 3) (re.++ (re.union (re.union (re.union (re.++ (str.to_re "2") (re.++ (re.range "0" "5") (re.range "0" "5"))) (re.++ (str.to_re "1") (re.++ (re.range "0" "9") (re.range "0" "9")))) (re.++ (re.range "1" "9") (re.range "0" "9"))) (re.range "0" "9")) (str.to_re "."))) (re.++ (re.union (re.union (re.union (re.++ (str.to_re "2") (re.++ (re.range "0" "5") (re.range "0" "5"))) (re.++ (str.to_re "1") (re.++ (re.range "0" "9") (re.range "0" "9")))) (re.++ (re.range "1" "9") (re.range "0" "9"))) (re.range "0" "9")) (re.++ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) (re.++ (str.to_re "5") ((_ re.loop 3 3) (re.range "0" "9"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)