;test regex \text1{123}\text2{123}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{09}") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re "t") (re.++ ((_ re.loop 123 123) (str.to_re "1")) (re.++ (str.to_re "\u{09}") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (re.++ (str.to_re "t") ((_ re.loop 123 123) (str.to_re "2")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)