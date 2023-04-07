;test regex ^([L|W|H]\*{0,1})?(([L|W|H]\*{0,1}){0,9})?([L|W|H]{0,1})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.opt (re.++ (re.union (str.to_re "L") (re.union (str.to_re "|") (re.union (str.to_re "W") (re.union (str.to_re "|") (str.to_re "H"))))) ((_ re.loop 0 1) (str.to_re "*")))) (re.++ (re.opt ((_ re.loop 0 9) (re.++ (re.union (str.to_re "L") (re.union (str.to_re "|") (re.union (str.to_re "W") (re.union (str.to_re "|") (str.to_re "H"))))) ((_ re.loop 0 1) (str.to_re "*"))))) ((_ re.loop 0 1) (re.union (str.to_re "L") (re.union (str.to_re "|") (re.union (str.to_re "W") (re.union (str.to_re "|") (str.to_re "H"))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)