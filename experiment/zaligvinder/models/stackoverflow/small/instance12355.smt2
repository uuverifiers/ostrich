;test regex ^a{1,6}$|^b{1,6}$|^c{1,6}$|^d{1,6}$|^e{1,6}$|^f{1,6}$|^g{1,6}$|^[i]{2,3}$
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.++ (re.++ (str.to_re "") ((_ re.loop 1 6) (str.to_re "a"))) (str.to_re "")) (re.++ (re.++ (str.to_re "") ((_ re.loop 1 6) (str.to_re "b"))) (str.to_re ""))) (re.++ (re.++ (str.to_re "") ((_ re.loop 1 6) (str.to_re "c"))) (str.to_re ""))) (re.++ (re.++ (str.to_re "") ((_ re.loop 1 6) (str.to_re "d"))) (str.to_re ""))) (re.++ (re.++ (str.to_re "") ((_ re.loop 1 6) (str.to_re "e"))) (str.to_re ""))) (re.++ (re.++ (str.to_re "") ((_ re.loop 1 6) (str.to_re "f"))) (str.to_re ""))) (re.++ (re.++ (str.to_re "") ((_ re.loop 1 6) (str.to_re "g"))) (str.to_re ""))) (re.++ (re.++ (str.to_re "") ((_ re.loop 2 3) (str.to_re "i"))) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)