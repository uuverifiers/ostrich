;test regex (a{4}Ua{2}bUb{2})(aUb)*
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ ((_ re.loop 4 4) (str.to_re "a")) (re.++ (str.to_re "U") (re.++ ((_ re.loop 2 2) (str.to_re "a")) (re.++ (str.to_re "b") (re.++ (str.to_re "U") ((_ re.loop 2 2) (str.to_re "b"))))))) (re.* (re.++ (str.to_re "a") (re.++ (str.to_re "U") (str.to_re "b")))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)