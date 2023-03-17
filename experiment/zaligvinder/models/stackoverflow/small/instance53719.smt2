;test regex ^[A]?((A[g-p])|([FDQX][g-p]{2}))$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.opt (str.to_re "A")) (re.union (re.++ (str.to_re "A") (re.range "g" "p")) (re.++ (re.union (str.to_re "F") (re.union (str.to_re "D") (re.union (str.to_re "Q") (str.to_re "X")))) ((_ re.loop 2 2) (re.range "g" "p")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)