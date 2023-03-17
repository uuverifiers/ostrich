;test regex ^EM1650S(B{1,2}|L{1,2})?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "E") (re.++ (str.to_re "M") (re.++ (str.to_re "1650") (re.++ (str.to_re "S") (re.opt (re.union ((_ re.loop 1 2) (str.to_re "B")) ((_ re.loop 1 2) (str.to_re "L"))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)