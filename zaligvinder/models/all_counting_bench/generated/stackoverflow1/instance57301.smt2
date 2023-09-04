;test regex (\+|00)\d{2,3}-{0,1}\d{8,10}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.union (str.to_re "+") (str.to_re "00")) (re.++ ((_ re.loop 2 3) (re.range "0" "9")) (re.++ ((_ re.loop 0 1) (str.to_re "-")) ((_ re.loop 8 10) (re.range "0" "9"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)