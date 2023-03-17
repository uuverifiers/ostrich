;test regex ^0(5[012345678]|6[47]){1}(\-)?[^0\D]{1}\d{5}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "0") (re.++ ((_ re.loop 1 1) (re.union (re.++ (str.to_re "5") (str.to_re "012345678")) (re.++ (str.to_re "6") (str.to_re "47")))) (re.++ (re.opt (str.to_re "-")) (re.++ ((_ re.loop 1 1) (re.inter (re.diff re.allchar (str.to_re "0")) (re.diff re.allchar (re.diff re.allchar (re.range "0" "9"))))) ((_ re.loop 5 5) (re.range "0" "9"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)