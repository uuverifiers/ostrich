;test regex ^(\+?1)?(8(00|44|55|66|77|88)[2-9]\d{6})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.opt (re.++ (re.opt (str.to_re "+")) (str.to_re "1"))) (re.++ (str.to_re "8") (re.++ (re.union (re.union (re.union (re.union (re.union (str.to_re "00") (str.to_re "44")) (str.to_re "55")) (str.to_re "66")) (str.to_re "77")) (str.to_re "88")) (re.++ (re.range "2" "9") ((_ re.loop 6 6) (re.range "0" "9"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)