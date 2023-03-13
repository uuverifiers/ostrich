;test regex ^PM_IG(\\d{5})_(\\d{1,2})_
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (str.to_re "P") (re.++ (str.to_re "M") (re.++ (str.to_re "_") (re.++ (str.to_re "I") (re.++ (str.to_re "G") (re.++ (re.++ (str.to_re "\\") ((_ re.loop 5 5) (str.to_re "d"))) (re.++ (str.to_re "_") (re.++ (re.++ (str.to_re "\\") ((_ re.loop 1 2) (str.to_re "d"))) (str.to_re "_"))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)