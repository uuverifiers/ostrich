;test regex \\d{1,2}(\\s[xX]|[xX])
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\\") (re.++ ((_ re.loop 1 2) (str.to_re "d")) (re.union (re.++ (str.to_re "\\") (re.++ (str.to_re "s") (re.union (str.to_re "x") (str.to_re "X")))) (re.union (str.to_re "x") (str.to_re "X")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)