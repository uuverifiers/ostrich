;test regex ^((((\(\d{3}\))|(\d{3}-))\d{3}-\d{4})|(\+?\d{2}((-| )\d{1,8}){1,5}))(( x| ext)\d{1,5}){0,1}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.++ (re.union (re.++ (str.to_re "(") (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ")"))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-"))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9"))))) (re.++ (re.opt (str.to_re "+")) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 1 5) (re.++ (re.union (str.to_re "-") (str.to_re " ")) ((_ re.loop 1 8) (re.range "0" "9"))))))) ((_ re.loop 0 1) (re.++ (re.union (re.++ (str.to_re " ") (str.to_re "x")) (re.++ (str.to_re " ") (re.++ (str.to_re "e") (re.++ (str.to_re "x") (str.to_re "t"))))) ((_ re.loop 1 5) (re.range "0" "9")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)