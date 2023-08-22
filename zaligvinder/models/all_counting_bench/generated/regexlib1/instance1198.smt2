;test regex ((\(\d{3,4}\)|\d{3,4}-)\d{4,9}(-\d{1,5}|\d{0}))|(\d{4,12})
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (re.union (re.++ (str.to_re "(") (re.++ ((_ re.loop 3 4) (re.range "0" "9")) (str.to_re ")"))) (re.++ ((_ re.loop 3 4) (re.range "0" "9")) (str.to_re "-"))) (re.++ ((_ re.loop 4 9) (re.range "0" "9")) (re.union (re.++ (str.to_re "-") ((_ re.loop 1 5) (re.range "0" "9"))) ((_ re.loop 0 0) (re.range "0" "9"))))) ((_ re.loop 4 12) (re.range "0" "9")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)