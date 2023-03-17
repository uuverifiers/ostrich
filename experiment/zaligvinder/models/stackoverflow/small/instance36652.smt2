;test regex ((ab[cC])+(XY)*){1,5}
(declare-const X String)
(assert (str.in_re X ((_ re.loop 1 5) (re.++ (re.+ (re.++ (str.to_re "a") (re.++ (str.to_re "b") (re.union (str.to_re "c") (str.to_re "C"))))) (re.* (re.++ (str.to_re "X") (str.to_re "Y")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)