;test regex ^Bearer\s[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "B") (re.++ (str.to_re "e") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) (re.++ ((_ re.loop 8 8) (re.union (re.range "a" "f") (re.range "0" "9"))) (re.++ (str.to_re "-") (re.++ ((_ re.loop 4 4) (re.union (re.range "a" "f") (re.range "0" "9"))) (re.++ (str.to_re "-") (re.++ ((_ re.loop 4 4) (re.union (re.range "a" "f") (re.range "0" "9"))) (re.++ (str.to_re "-") (re.++ ((_ re.loop 4 4) (re.union (re.range "a" "f") (re.range "0" "9"))) (re.++ (str.to_re "-") ((_ re.loop 12 12) (re.union (re.range "a" "f") (re.range "0" "9"))))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)