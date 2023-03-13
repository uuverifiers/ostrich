;test regex foo((bar){2,3}|potato)
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "f") (re.++ (str.to_re "o") (re.++ (str.to_re "o") (re.union ((_ re.loop 2 3) (re.++ (str.to_re "b") (re.++ (str.to_re "a") (str.to_re "r")))) (re.++ (str.to_re "p") (re.++ (str.to_re "o") (re.++ (str.to_re "t") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (str.to_re "o"))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)