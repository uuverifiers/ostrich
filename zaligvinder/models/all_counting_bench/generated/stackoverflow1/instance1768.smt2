;test regex \[[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z-0-9]{12}\]
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "[") (re.++ ((_ re.loop 8 8) (re.union (re.range "a" "z") (re.range "0" "9"))) (re.++ (str.to_re "-") (re.++ ((_ re.loop 4 4) (re.union (re.range "a" "z") (re.range "0" "9"))) (re.++ (str.to_re "-") (re.++ ((_ re.loop 4 4) (re.union (re.range "a" "z") (re.range "0" "9"))) (re.++ (str.to_re "-") (re.++ ((_ re.loop 4 4) (re.union (re.range "a" "z") (re.range "0" "9"))) (re.++ (str.to_re "-") (re.++ ((_ re.loop 12 12) (re.union (re.range "a" "z") (re.union (str.to_re "-") (re.range "0" "9")))) (str.to_re "]")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)