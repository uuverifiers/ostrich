;test regex (1abc\\d{2})|(2abc\\d{3})|(3abc\\d{4})
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (str.to_re "1") (re.++ (str.to_re "a") (re.++ (str.to_re "b") (re.++ (str.to_re "c") (re.++ (str.to_re "\\") ((_ re.loop 2 2) (str.to_re "d"))))))) (re.++ (str.to_re "2") (re.++ (str.to_re "a") (re.++ (str.to_re "b") (re.++ (str.to_re "c") (re.++ (str.to_re "\\") ((_ re.loop 3 3) (str.to_re "d")))))))) (re.++ (str.to_re "3") (re.++ (str.to_re "a") (re.++ (str.to_re "b") (re.++ (str.to_re "c") (re.++ (str.to_re "\\") ((_ re.loop 4 4) (str.to_re "d"))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)