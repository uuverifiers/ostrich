;test regex ^(([1-9][0-9]{0,2}|[1-3][0-9][0-9][0-9]|40([0-8][0-9]|9[0-6]))(,\s*[1-9][0-9]{0,2}|[1-3][0-9][0-9][0-9]|40([0-8][0-9]|9[0-6]))*)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.union (re.++ (re.range "1" "9") ((_ re.loop 0 2) (re.range "0" "9"))) (re.++ (re.range "1" "3") (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.range "0" "9"))))) (re.++ (str.to_re "40") (re.union (re.++ (re.range "0" "8") (re.range "0" "9")) (re.++ (str.to_re "9") (re.range "0" "6"))))) (re.* (re.union (re.union (re.++ (str.to_re ",") (re.++ (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ (re.range "1" "9") ((_ re.loop 0 2) (re.range "0" "9"))))) (re.++ (re.range "1" "3") (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.range "0" "9"))))) (re.++ (str.to_re "40") (re.union (re.++ (re.range "0" "8") (re.range "0" "9")) (re.++ (str.to_re "9") (re.range "0" "6")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)