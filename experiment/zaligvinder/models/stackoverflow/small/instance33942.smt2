;test regex (^([+]{1}[8]{2}|0088)?(01){1}[5-9]{1}\d{8})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.opt (re.union (re.++ ((_ re.loop 1 1) (str.to_re "+")) ((_ re.loop 2 2) (str.to_re "8"))) (str.to_re "0088"))) (re.++ ((_ re.loop 1 1) (str.to_re "01")) (re.++ ((_ re.loop 1 1) (re.range "5" "9")) ((_ re.loop 8 8) (re.range "0" "9")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)