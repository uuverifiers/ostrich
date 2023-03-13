;test regex ([\r\n]{4,}|[\n]{2,}|[\r]{2,})
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) ((_ re.loop 4 4) (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}")))) (re.++ (re.* (str.to_re "\u{0a}")) ((_ re.loop 2 2) (str.to_re "\u{0a}")))) (re.++ (re.* (str.to_re "\u{0d}")) ((_ re.loop 2 2) (str.to_re "\u{0d}"))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)