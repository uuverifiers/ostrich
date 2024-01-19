;test regex [fli]{2,}
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.union (str.to_re "f") (re.union (str.to_re "l") (str.to_re "i")))) ((_ re.loop 2 2) (re.union (str.to_re "f") (re.union (str.to_re "l") (str.to_re "i")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)