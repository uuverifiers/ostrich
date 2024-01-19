;test regex (C[MD]|D?C{0,3})
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "C") (re.union (str.to_re "M") (str.to_re "D"))) (re.++ (re.opt (str.to_re "D")) ((_ re.loop 0 3) (str.to_re "C"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)