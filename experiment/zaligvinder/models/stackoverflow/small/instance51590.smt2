;test regex (MAY|NAY|POL)[01]{4}
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.union (re.++ (str.to_re "M") (re.++ (str.to_re "A") (str.to_re "Y"))) (re.++ (str.to_re "N") (re.++ (str.to_re "A") (str.to_re "Y")))) (re.++ (str.to_re "P") (re.++ (str.to_re "O") (str.to_re "L")))) ((_ re.loop 4 4) (str.to_re "01")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)