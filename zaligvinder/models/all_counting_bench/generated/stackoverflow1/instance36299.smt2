;test regex ((\d{0,3})[ .-]?(\d{5,11}))
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 0 3) (re.range "0" "9")) (re.++ (re.opt (re.union (str.to_re " ") (re.union (str.to_re ".") (str.to_re "-")))) ((_ re.loop 5 11) (re.range "0" "9"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)