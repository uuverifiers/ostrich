;test regex (([0-9a-fA-F]{2} ?){6}\r\n?)+
(declare-const X String)
(assert (str.in_re X (re.+ (re.++ ((_ re.loop 6 6) (re.++ ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.union (re.range "a" "f") (re.range "A" "F")))) (re.opt (str.to_re " ")))) (re.++ (str.to_re "\u{0d}") (re.opt (str.to_re "\u{0a}")))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)