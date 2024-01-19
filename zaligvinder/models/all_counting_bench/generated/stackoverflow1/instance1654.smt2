;test regex ^(\+26461(\d{6})|\+2648(\d{8})|08(1|5)(\d{7})|061(\d{6}))$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union (re.union (re.++ (str.to_re "+") (re.++ (str.to_re "26461") ((_ re.loop 6 6) (re.range "0" "9")))) (re.++ (str.to_re "+") (re.++ (str.to_re "2648") ((_ re.loop 8 8) (re.range "0" "9"))))) (re.++ (str.to_re "08") (re.++ (re.union (str.to_re "1") (str.to_re "5")) ((_ re.loop 7 7) (re.range "0" "9"))))) (re.++ (str.to_re "061") ((_ re.loop 6 6) (re.range "0" "9"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)