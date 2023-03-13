;test regex ^(abc|def)([0-9]{1,2}|[1-8][0-9]{2}|900)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.union (re.++ (str.to_re "a") (re.++ (str.to_re "b") (str.to_re "c"))) (re.++ (str.to_re "d") (re.++ (str.to_re "e") (str.to_re "f")))) (re.union (re.union ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (re.range "1" "8") ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "900"))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)