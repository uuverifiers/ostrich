;test regex ([Gg][Ii][Rr] 0[Aa]{2})
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (str.to_re "G") (str.to_re "g")) (re.++ (re.union (str.to_re "I") (str.to_re "i")) (re.++ (re.union (str.to_re "R") (str.to_re "r")) (re.++ (str.to_re " ") (re.++ (str.to_re "0") ((_ re.loop 2 2) (re.union (str.to_re "A") (str.to_re "a"))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)