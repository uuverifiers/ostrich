;test regex ^(aa|bb){1}(a*)(ab){1}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 1 1) (re.union (re.++ (str.to_re "a") (str.to_re "a")) (re.++ (str.to_re "b") (str.to_re "b")))) (re.++ (re.* (str.to_re "a")) ((_ re.loop 1 1) (re.++ (str.to_re "a") (str.to_re "b")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)