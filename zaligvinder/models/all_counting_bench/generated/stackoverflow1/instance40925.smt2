;test regex ^(abc|def)(900|0|[1-8]?[0-9]{0,2})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.++ (str.to_re "a") (re.++ (str.to_re "b") (str.to_re "c"))) (re.++ (str.to_re "d") (re.++ (str.to_re "e") (str.to_re "f")))) (re.union (re.union (str.to_re "900") (str.to_re "0")) (re.++ (re.opt (re.range "1" "8")) ((_ re.loop 0 2) (re.range "0" "9")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)