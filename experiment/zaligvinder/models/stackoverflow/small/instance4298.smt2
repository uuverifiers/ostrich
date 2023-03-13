;test regex ([2017]{4})([04]{2})([18]{2})
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 4 4) (str.to_re "2017")) (re.++ ((_ re.loop 2 2) (str.to_re "04")) ((_ re.loop 2 2) (str.to_re "18"))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)