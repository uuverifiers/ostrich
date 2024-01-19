;test regex ([0-9]+[B]){1}+([0-9]+[M])?+([0-9]+[T])?+([0-9]+[H])?
(declare-const X String)
(assert (str.in_re X (re.++ (re.+ ((_ re.loop 1 1) (re.++ (re.+ (re.range "0" "9")) (str.to_re "B")))) (re.++ (re.+ (re.opt (re.++ (re.+ (re.range "0" "9")) (str.to_re "M")))) (re.++ (re.+ (re.opt (re.++ (re.+ (re.range "0" "9")) (str.to_re "T")))) (re.opt (re.++ (re.+ (re.range "0" "9")) (str.to_re "H"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)