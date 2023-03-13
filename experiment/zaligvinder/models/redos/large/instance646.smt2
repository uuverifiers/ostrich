;test regex ^[\u0430-\u044fa-z0-9.-]{2,255}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") ((_ re.loop 2 255) (re.union (re.range "\u{0430}" "\u{044fa}") (re.union (str.to_re "-") (re.union (str.to_re "z") (re.union (re.range "0" "9") (re.union (str.to_re ".") (str.to_re "-")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)