;test regex (m{0,4}(?:cm|cd|d?c{0,3})(?:xc|xl|l?x{0,3})(?:ix|iv|v?i{0,3}))
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 0 4) (str.to_re "m")) (re.++ (re.union (re.union (re.++ (str.to_re "c") (str.to_re "m")) (re.++ (str.to_re "c") (str.to_re "d"))) (re.++ (re.opt (str.to_re "d")) ((_ re.loop 0 3) (str.to_re "c")))) (re.++ (re.union (re.union (re.++ (str.to_re "x") (str.to_re "c")) (re.++ (str.to_re "x") (str.to_re "l"))) (re.++ (re.opt (str.to_re "l")) ((_ re.loop 0 3) (str.to_re "x")))) (re.union (re.union (re.++ (str.to_re "i") (str.to_re "x")) (re.++ (str.to_re "i") (str.to_re "v"))) (re.++ (re.opt (str.to_re "v")) ((_ re.loop 0 3) (str.to_re "i")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)