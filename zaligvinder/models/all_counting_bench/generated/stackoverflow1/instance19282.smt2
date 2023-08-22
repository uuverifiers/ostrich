;test regex (\+?92)30[0-9]{8}|030[0-9]{8}
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (re.++ (re.opt (str.to_re "+")) (str.to_re "92")) (re.++ (str.to_re "30") ((_ re.loop 8 8) (re.range "0" "9")))) (re.++ (str.to_re "030") ((_ re.loop 8 8) (re.range "0" "9"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)