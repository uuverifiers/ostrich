;test regex ^(?:09|\+?63)(?:\d(?:-)?){9,10}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (str.to_re "09") (re.++ (re.opt (str.to_re "+")) (str.to_re "63"))) ((_ re.loop 9 10) (re.++ (re.range "0" "9") (re.opt (str.to_re "-")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)