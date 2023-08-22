;test regex (^(\+88|0088)?(01){1}[56789]{1}(\d){8})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.opt (re.union (re.++ (str.to_re "+") (str.to_re "88")) (str.to_re "0088"))) (re.++ ((_ re.loop 1 1) (str.to_re "01")) (re.++ ((_ re.loop 1 1) (str.to_re "56789")) ((_ re.loop 8 8) (re.range "0" "9")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)