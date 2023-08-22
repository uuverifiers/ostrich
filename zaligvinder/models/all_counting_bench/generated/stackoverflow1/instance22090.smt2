;test regex (,{0,1}x1,(x2,){0,1}x3,{0,1}){3}
(declare-const X String)
(assert (str.in_re X ((_ re.loop 3 3) (re.++ (re.++ (re.++ ((_ re.loop 0 1) (str.to_re ",")) (re.++ (str.to_re "x") (str.to_re "1"))) (re.++ (str.to_re ",") (re.++ ((_ re.loop 0 1) (re.++ (re.++ (str.to_re "x") (str.to_re "2")) (str.to_re ","))) (re.++ (str.to_re "x") (str.to_re "3"))))) ((_ re.loop 0 1) (str.to_re ","))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)