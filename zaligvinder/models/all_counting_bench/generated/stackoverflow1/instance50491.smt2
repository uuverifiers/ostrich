;test regex ([\\]{4})(\d*)([\\]{2}\d+)?([\\]{2}\d+)?
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 4 4) (str.to_re "\\")) (re.++ (re.* (re.range "0" "9")) (re.++ (re.opt (re.++ ((_ re.loop 2 2) (str.to_re "\\")) (re.+ (re.range "0" "9")))) (re.opt (re.++ ((_ re.loop 2 2) (str.to_re "\\")) (re.+ (re.range "0" "9")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)