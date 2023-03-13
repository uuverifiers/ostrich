;test regex BASIC{76}XXXXX{98}zzzz
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "B") (re.++ (str.to_re "A") (re.++ (str.to_re "S") (re.++ (str.to_re "I") (re.++ ((_ re.loop 76 76) (str.to_re "C")) (re.++ (str.to_re "X") (re.++ (str.to_re "X") (re.++ (str.to_re "X") (re.++ (str.to_re "X") (re.++ ((_ re.loop 98 98) (str.to_re "X")) (re.++ (str.to_re "z") (re.++ (str.to_re "z") (re.++ (str.to_re "z") (str.to_re "z"))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)