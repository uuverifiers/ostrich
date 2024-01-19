;test regex (?:[bB]|[lIi]3)[0Oo]{2}
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.union (str.to_re "b") (str.to_re "B")) (re.++ (re.union (str.to_re "l") (re.union (str.to_re "I") (str.to_re "i"))) (str.to_re "3"))) ((_ re.loop 2 2) (re.union (str.to_re "0") (re.union (str.to_re "O") (str.to_re "o")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)