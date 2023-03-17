;test regex ^[^ab]*(a{1,2}|b{1,2}|\z)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.* (re.inter (re.diff re.allchar (str.to_re "a")) (re.diff re.allchar (str.to_re "b")))) (re.union (re.union ((_ re.loop 1 2) (str.to_re "a")) ((_ re.loop 1 2) (str.to_re "b"))) (str.to_re "z"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)