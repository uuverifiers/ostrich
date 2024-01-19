;test regex ^(((2|8|9)\d{2})|((02|08|09)\d{2})|([1-9]\d{3}))$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union (re.++ (re.union (re.union (str.to_re "2") (str.to_re "8")) (str.to_re "9")) ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (re.union (re.union (str.to_re "02") (str.to_re "08")) (str.to_re "09")) ((_ re.loop 2 2) (re.range "0" "9")))) (re.++ (re.range "1" "9") ((_ re.loop 3 3) (re.range "0" "9"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)