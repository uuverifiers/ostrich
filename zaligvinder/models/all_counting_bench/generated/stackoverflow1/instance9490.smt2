;test regex "a((bcd){2}ef){2}g"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "a") (re.++ ((_ re.loop 2 2) (re.++ ((_ re.loop 2 2) (re.++ (str.to_re "b") (re.++ (str.to_re "c") (str.to_re "d")))) (re.++ (str.to_re "e") (str.to_re "f")))) (re.++ (str.to_re "g") (str.to_re "\u{22}")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)