;test regex r'^(?:\+?44)?[07]\d{9,13}$'
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "r") (str.to_re "\u{27}")) (re.++ (str.to_re "") (re.++ (re.opt (re.++ (re.opt (str.to_re "+")) (str.to_re "44"))) (re.++ (str.to_re "07") ((_ re.loop 9 13) (re.range "0" "9")))))) (re.++ (str.to_re "") (str.to_re "\u{27}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)