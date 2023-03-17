;test regex ^0*(?:[1-9]\d{0,3})?(?:\.0*(?:[1-9]\d{0,3})?)?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.* (str.to_re "0")) (re.++ (re.opt (re.++ (re.range "1" "9") ((_ re.loop 0 3) (re.range "0" "9")))) (re.opt (re.++ (str.to_re ".") (re.++ (re.* (str.to_re "0")) (re.opt (re.++ (re.range "1" "9") ((_ re.loop 0 3) (re.range "0" "9")))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)