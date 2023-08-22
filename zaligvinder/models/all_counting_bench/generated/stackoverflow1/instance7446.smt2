;test regex ^(10429|104[3-9]\d|10[5-9]\d{2}|1[1-9]\d{3}|[2-3]\d{4}|40\d{3})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union (re.union (re.union (re.union (str.to_re "10429") (re.++ (str.to_re "104") (re.++ (re.range "3" "9") (re.range "0" "9")))) (re.++ (str.to_re "10") (re.++ (re.range "5" "9") ((_ re.loop 2 2) (re.range "0" "9"))))) (re.++ (str.to_re "1") (re.++ (re.range "1" "9") ((_ re.loop 3 3) (re.range "0" "9"))))) (re.++ (re.range "2" "3") ((_ re.loop 4 4) (re.range "0" "9")))) (re.++ (str.to_re "40") ((_ re.loop 3 3) (re.range "0" "9"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)