;test regex ^(CL)*(RH(CL)*){0,2}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.* (re.++ (str.to_re "C") (str.to_re "L"))) ((_ re.loop 0 2) (re.++ (str.to_re "R") (re.++ (str.to_re "H") (re.* (re.++ (str.to_re "C") (str.to_re "L")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)