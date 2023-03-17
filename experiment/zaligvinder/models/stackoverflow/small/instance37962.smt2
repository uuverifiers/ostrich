;test regex ^[A-Z][a-z]{2}\s\d\d-\d\d
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.range "A" "Z") (re.++ ((_ re.loop 2 2) (re.range "a" "z")) (re.++ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.++ (str.to_re "-") (re.++ (re.range "0" "9") (re.range "0" "9")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)