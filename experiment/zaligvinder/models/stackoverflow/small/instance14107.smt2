;test regex \{(?:DD|MM|YY|N{2,6})\}
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "{") (re.++ (re.union (re.union (re.union (re.++ (str.to_re "D") (str.to_re "D")) (re.++ (str.to_re "M") (str.to_re "M"))) (re.++ (str.to_re "Y") (str.to_re "Y"))) ((_ re.loop 2 6) (str.to_re "N"))) (str.to_re "}")))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)