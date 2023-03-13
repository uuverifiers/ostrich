;test regex ^(?:[1-9]\d{0,2}|[1-3]\d{3}|40(?:[0-8]\d|9[0-3]))(?:[,-] *(?:[1-9]\d{0,2}|[1-3]\d{3}|40(?:[0-8]\d|9[0-3]))?)*$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.union (re.++ (re.range "1" "9") ((_ re.loop 0 2) (re.range "0" "9"))) (re.++ (re.range "1" "3") ((_ re.loop 3 3) (re.range "0" "9")))) (re.++ (str.to_re "40") (re.union (re.++ (re.range "0" "8") (re.range "0" "9")) (re.++ (str.to_re "9") (re.range "0" "3"))))) (re.* (re.++ (re.union (str.to_re ",") (str.to_re "-")) (re.++ (re.* (str.to_re " ")) (re.opt (re.union (re.union (re.++ (re.range "1" "9") ((_ re.loop 0 2) (re.range "0" "9"))) (re.++ (re.range "1" "3") ((_ re.loop 3 3) (re.range "0" "9")))) (re.++ (str.to_re "40") (re.union (re.++ (re.range "0" "8") (re.range "0" "9")) (re.++ (str.to_re "9") (re.range "0" "3"))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)