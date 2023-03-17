;test regex (XC|XL|L?X{0,3})
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (str.to_re "X") (str.to_re "C")) (re.++ (str.to_re "X") (str.to_re "L"))) (re.++ (re.opt (str.to_re "L")) ((_ re.loop 0 3) (str.to_re "X"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)