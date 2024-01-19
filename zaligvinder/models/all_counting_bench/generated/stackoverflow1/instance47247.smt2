;test regex r'^a{0,2}b{0,3}c{0,3}d{0,1}e{0,1}$'
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "r") (str.to_re "\u{27}")) (re.++ (str.to_re "") (re.++ ((_ re.loop 0 2) (str.to_re "a")) (re.++ ((_ re.loop 0 3) (str.to_re "b")) (re.++ ((_ re.loop 0 3) (str.to_re "c")) (re.++ ((_ re.loop 0 1) (str.to_re "d")) ((_ re.loop 0 1) (str.to_re "e")))))))) (re.++ (str.to_re "") (str.to_re "\u{27}")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)