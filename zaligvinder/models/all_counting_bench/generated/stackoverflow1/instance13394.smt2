;test regex /^I(?:I{0,2}|V)\/[ABCD]$/
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "/") (re.++ (str.to_re "") (re.++ (str.to_re "I") (re.++ (re.union ((_ re.loop 0 2) (str.to_re "I")) (str.to_re "V")) (re.++ (str.to_re "/") (re.union (str.to_re "A") (re.union (str.to_re "B") (re.union (str.to_re "C") (str.to_re "D"))))))))) (re.++ (str.to_re "") (str.to_re "/")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)