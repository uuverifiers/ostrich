;test regex [functio]{8}
(declare-const X String)
(assert (str.in_re X ((_ re.loop 8 8) (re.union (str.to_re "f") (re.union (str.to_re "u") (re.union (str.to_re "n") (re.union (str.to_re "c") (re.union (str.to_re "t") (re.union (str.to_re "i") (str.to_re "o"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)