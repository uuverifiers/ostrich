;test regex (jsx?|scs{2})
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "j") (re.++ (str.to_re "s") (re.opt (str.to_re "x")))) (re.++ (str.to_re "s") (re.++ (str.to_re "c") ((_ re.loop 2 2) (str.to_re "s")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)