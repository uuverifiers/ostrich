;test regex 10429|104[3-9][0-9]|10[5-9][0-9]{2}|1[1-9][0-9]{3}|[23][0-9]{4}|40[0-9]{3}
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.union (re.union (str.to_re "10429") (re.++ (str.to_re "104") (re.++ (re.range "3" "9") (re.range "0" "9")))) (re.++ (str.to_re "10") (re.++ (re.range "5" "9") ((_ re.loop 2 2) (re.range "0" "9"))))) (re.++ (str.to_re "1") (re.++ (re.range "1" "9") ((_ re.loop 3 3) (re.range "0" "9"))))) (re.++ (str.to_re "23") ((_ re.loop 4 4) (re.range "0" "9")))) (re.++ (str.to_re "40") ((_ re.loop 3 3) (re.range "0" "9"))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)