;test regex ^((AQ|VQ)-)?(\\d{5})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.opt (re.++ (re.union (re.++ (str.to_re "A") (str.to_re "Q")) (re.++ (str.to_re "V") (str.to_re "Q"))) (str.to_re "-"))) (re.++ (str.to_re "\\") ((_ re.loop 5 5) (str.to_re "d"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)