;test regex ^(\d+[yY])?(\d{1,2}[mM])?(\d{1,2}o?[dD])?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.opt (re.++ (re.+ (re.range "0" "9")) (re.union (str.to_re "y") (str.to_re "Y")))) (re.++ (re.opt (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.union (str.to_re "m") (str.to_re "M")))) (re.opt (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (re.opt (str.to_re "o")) (re.union (str.to_re "d") (str.to_re "D")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)