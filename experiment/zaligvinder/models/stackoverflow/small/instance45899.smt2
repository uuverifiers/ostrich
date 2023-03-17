;test regex string p1 = "^m*(d?c{0,3}|c[dm])"+ "(l?x{0,3}|x[lc])(v?i{0,3}|i[vx])$";
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "s") (re.++ (str.to_re "t") (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "n") (re.++ (str.to_re "g") (re.++ (str.to_re " ") (re.++ (str.to_re "p") (re.++ (str.to_re "1") (re.++ (str.to_re " ") (re.++ (str.to_re "=") (re.++ (str.to_re " ") (str.to_re "\u{22}"))))))))))))) (re.++ (str.to_re "") (re.++ (re.* (str.to_re "m")) (re.++ (re.union (re.++ (re.opt (str.to_re "d")) ((_ re.loop 0 3) (str.to_re "c"))) (re.++ (str.to_re "c") (re.union (str.to_re "d") (str.to_re "m")))) (re.++ (re.+ (str.to_re "\u{22}")) (re.++ (str.to_re " ") (re.++ (str.to_re "\u{22}") (re.++ (re.union (re.++ (re.opt (str.to_re "l")) ((_ re.loop 0 3) (str.to_re "x"))) (re.++ (str.to_re "x") (re.union (str.to_re "l") (str.to_re "c")))) (re.union (re.++ (re.opt (str.to_re "v")) ((_ re.loop 0 3) (str.to_re "i"))) (re.++ (str.to_re "i") (re.union (str.to_re "v") (str.to_re "x")))))))))))) (re.++ (str.to_re "") (re.++ (str.to_re "\u{22}") (str.to_re ";"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)