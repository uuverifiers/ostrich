;test regex (\+359|0)\s?8(\d{2}\s\d{3}\d{3}|[789]\d{7})
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "+") (str.to_re "359")) (str.to_re "0")) (re.++ (re.opt (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) (re.++ (str.to_re "8") (re.union (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 3 3) (re.range "0" "9"))))) (re.++ (str.to_re "789") ((_ re.loop 7 7) (re.range "0" "9")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)