;test regex (00356)?(99|79|77|21|27|22|25)[0-9]{6}
(declare-const X String)
(assert (str.in_re X (re.++ (re.opt (str.to_re "00356")) (re.++ (re.union (re.union (re.union (re.union (re.union (re.union (str.to_re "99") (str.to_re "79")) (str.to_re "77")) (str.to_re "21")) (str.to_re "27")) (str.to_re "22")) (str.to_re "25")) ((_ re.loop 6 6) (re.range "0" "9"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)