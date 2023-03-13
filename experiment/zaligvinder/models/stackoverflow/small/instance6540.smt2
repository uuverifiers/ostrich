;test regex ^D0{0,2}$|^(D0{1,2})+D?$
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "D") ((_ re.loop 0 2) (str.to_re "0")))) (str.to_re "")) (re.++ (re.++ (str.to_re "") (re.++ (re.+ (re.++ (str.to_re "D") ((_ re.loop 1 2) (str.to_re "0")))) (re.opt (str.to_re "D")))) (str.to_re "")))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)