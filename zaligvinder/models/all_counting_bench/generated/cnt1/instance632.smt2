;test regex 97[89]{1}(?:-?\d){10,16}|97[89]{1}[- 0-9]{10,16}
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "97") (re.++ ((_ re.loop 1 1) (str.to_re "89")) ((_ re.loop 10 16) (re.++ (re.opt (str.to_re "-")) (re.range "0" "9"))))) (re.++ (str.to_re "97") (re.++ ((_ re.loop 1 1) (str.to_re "89")) ((_ re.loop 10 16) (re.union (str.to_re "-") (re.union (str.to_re " ") (re.range "0" "9")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)