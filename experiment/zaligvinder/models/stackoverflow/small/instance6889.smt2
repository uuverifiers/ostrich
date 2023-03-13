;test regex \d{1}\.?\d{0,2}\/10
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (re.++ (re.opt (str.to_re ".")) (re.++ ((_ re.loop 0 2) (re.range "0" "9")) (re.++ (str.to_re "/") (str.to_re "10")))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)