;test regex (MMN{0,3})|(N{0,3}MM)
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "M") (re.++ (str.to_re "M") ((_ re.loop 0 3) (str.to_re "N")))) (re.++ ((_ re.loop 0 3) (str.to_re "N")) (re.++ (str.to_re "M") (str.to_re "M"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)