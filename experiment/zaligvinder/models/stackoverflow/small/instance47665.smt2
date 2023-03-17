;test regex "{0,1}HELLO"{0,1}
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 0 1) (str.to_re "\u{22}")) (re.++ (str.to_re "H") (re.++ (str.to_re "E") (re.++ (str.to_re "L") (re.++ (str.to_re "L") (re.++ (str.to_re "O") ((_ re.loop 0 1) (str.to_re "\u{22}"))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)