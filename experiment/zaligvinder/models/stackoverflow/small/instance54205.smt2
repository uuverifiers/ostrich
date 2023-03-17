;test regex ^(?:(\+|00)(49)?)?0?1\d{2,3}\d{8}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.opt (re.++ (re.union (str.to_re "+") (str.to_re "00")) (re.opt (str.to_re "49")))) (re.++ (re.opt (str.to_re "0")) (re.++ (str.to_re "1") (re.++ ((_ re.loop 2 3) (re.range "0" "9")) ((_ re.loop 8 8) (re.range "0" "9"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)