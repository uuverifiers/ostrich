;test regex ^[a-z0-9]{6,}[-_a-z0-9]{12,}[a-z0-9]{6,}\s*\z
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.++ (re.* (re.union (re.range "a" "z") (re.range "0" "9"))) ((_ re.loop 6 6) (re.union (re.range "a" "z") (re.range "0" "9")))) (re.++ (re.++ (re.* (re.union (str.to_re "-") (re.union (str.to_re "_") (re.union (re.range "a" "z") (re.range "0" "9"))))) ((_ re.loop 12 12) (re.union (str.to_re "-") (re.union (str.to_re "_") (re.union (re.range "a" "z") (re.range "0" "9")))))) (re.++ (re.++ (re.* (re.union (re.range "a" "z") (re.range "0" "9"))) ((_ re.loop 6 6) (re.union (re.range "a" "z") (re.range "0" "9")))) (re.++ (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (str.to_re "z"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)