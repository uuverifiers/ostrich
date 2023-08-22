;test regex ^((\+)?(\d{2}[-])?(\d{10}){1})?(\d{11}){0,1}?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.opt (re.++ (re.opt (str.to_re "+")) (re.++ (re.opt (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-"))) ((_ re.loop 1 1) ((_ re.loop 10 10) (re.range "0" "9")))))) ((_ re.loop 0 1) ((_ re.loop 11 11) (re.range "0" "9"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)