;test regex ^0{8}-0{4}-0{4}-0{4}-0{12}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 8 8) (str.to_re "0")) (re.++ (str.to_re "-") (re.++ ((_ re.loop 4 4) (str.to_re "0")) (re.++ (str.to_re "-") (re.++ ((_ re.loop 4 4) (str.to_re "0")) (re.++ (str.to_re "-") (re.++ ((_ re.loop 4 4) (str.to_re "0")) (re.++ (str.to_re "-") ((_ re.loop 12 12) (str.to_re "0"))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)