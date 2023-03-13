;test regex (?:T(?:(\d{6})Z?)?)?
(declare-const X String)
(assert (str.in_re X (re.opt (re.++ (str.to_re "T") (re.opt (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (re.opt (str.to_re "Z"))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)