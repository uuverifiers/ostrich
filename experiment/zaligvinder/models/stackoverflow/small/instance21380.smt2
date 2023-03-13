;test regex \A(^[A-Z]{0,10}$\r?\n?){0,3}\z
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "A") (re.++ ((_ re.loop 0 3) (re.++ (re.++ (str.to_re "") ((_ re.loop 0 10) (re.range "A" "Z"))) (re.++ (str.to_re "") (re.++ (re.opt (str.to_re "\u{0d}")) (re.opt (str.to_re "\u{0a}")))))) (str.to_re "z")))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)