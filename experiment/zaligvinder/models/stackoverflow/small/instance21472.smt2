;test regex ^M*(?:D?C{0,3}|C[MD])(?:L?X{0,3}|X[CL])(?:V?I{0,3}|I[XV])$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.* (str.to_re "M")) (re.++ (re.union (re.++ (re.opt (str.to_re "D")) ((_ re.loop 0 3) (str.to_re "C"))) (re.++ (str.to_re "C") (re.union (str.to_re "M") (str.to_re "D")))) (re.++ (re.union (re.++ (re.opt (str.to_re "L")) ((_ re.loop 0 3) (str.to_re "X"))) (re.++ (str.to_re "X") (re.union (str.to_re "C") (str.to_re "L")))) (re.union (re.++ (re.opt (str.to_re "V")) ((_ re.loop 0 3) (str.to_re "I"))) (re.++ (str.to_re "I") (re.union (str.to_re "X") (str.to_re "V")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)