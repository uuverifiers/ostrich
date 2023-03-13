;test regex ^a*(?:b+(?:a{2,})*)*bab(?:(?:a(?:a+b*)*)*|b+a*)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.* (str.to_re "a")) (re.++ (re.* (re.++ (re.+ (str.to_re "b")) (re.* (re.++ (re.* (str.to_re "a")) ((_ re.loop 2 2) (str.to_re "a")))))) (re.++ (str.to_re "b") (re.++ (str.to_re "a") (re.++ (str.to_re "b") (re.union (re.* (re.++ (str.to_re "a") (re.* (re.++ (re.+ (str.to_re "a")) (re.* (str.to_re "b")))))) (re.++ (re.+ (str.to_re "b")) (re.* (str.to_re "a")))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)