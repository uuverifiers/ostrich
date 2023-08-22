;test regex ^(x{10}y{10}|x{9}y{9}|x{8}y{8}|x{7}y{7}|x{6}y{6}|x{5}y{5}|x{4}y{4}|x{3}y{3}|x{2}y{2}|xy)?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.opt (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.++ ((_ re.loop 10 10) (str.to_re "x")) ((_ re.loop 10 10) (str.to_re "y"))) (re.++ ((_ re.loop 9 9) (str.to_re "x")) ((_ re.loop 9 9) (str.to_re "y")))) (re.++ ((_ re.loop 8 8) (str.to_re "x")) ((_ re.loop 8 8) (str.to_re "y")))) (re.++ ((_ re.loop 7 7) (str.to_re "x")) ((_ re.loop 7 7) (str.to_re "y")))) (re.++ ((_ re.loop 6 6) (str.to_re "x")) ((_ re.loop 6 6) (str.to_re "y")))) (re.++ ((_ re.loop 5 5) (str.to_re "x")) ((_ re.loop 5 5) (str.to_re "y")))) (re.++ ((_ re.loop 4 4) (str.to_re "x")) ((_ re.loop 4 4) (str.to_re "y")))) (re.++ ((_ re.loop 3 3) (str.to_re "x")) ((_ re.loop 3 3) (str.to_re "y")))) (re.++ ((_ re.loop 2 2) (str.to_re "x")) ((_ re.loop 2 2) (str.to_re "y")))) (re.++ (str.to_re "x") (str.to_re "y"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)