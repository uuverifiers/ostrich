;test regex  \A (?: x1, (?: x2, )? x3 ,? ){1,3} \z 
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re " ") (re.++ (str.to_re "A") (re.++ (str.to_re " ") (re.++ ((_ re.loop 1 3) (re.++ (re.++ (re.++ (str.to_re " ") (re.++ (str.to_re "x") (str.to_re "1"))) (re.++ (str.to_re ",") (re.++ (str.to_re " ") (re.++ (re.opt (re.++ (re.++ (str.to_re " ") (re.++ (str.to_re "x") (str.to_re "2"))) (re.++ (str.to_re ",") (str.to_re " ")))) (re.++ (str.to_re " ") (re.++ (str.to_re "x") (re.++ (str.to_re "3") (str.to_re " ")))))))) (re.++ (re.opt (str.to_re ",")) (str.to_re " ")))) (re.++ (str.to_re " ") (re.++ (str.to_re "z") (str.to_re " ")))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)