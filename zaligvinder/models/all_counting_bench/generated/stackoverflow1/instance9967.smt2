;test regex ^(D)([OAEES]{2})(R)([OAEES]{0,5})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "D") (re.++ ((_ re.loop 2 2) (re.union (str.to_re "O") (re.union (str.to_re "A") (re.union (str.to_re "E") (re.union (str.to_re "E") (str.to_re "S")))))) (re.++ (str.to_re "R") ((_ re.loop 0 5) (re.union (str.to_re "O") (re.union (str.to_re "A") (re.union (str.to_re "E") (re.union (str.to_re "E") (str.to_re "S")))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)