;test regex s/(?:.*?\t){9}\K/23424977/g
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "s") (re.++ (str.to_re "/") (re.++ ((_ re.loop 9 9) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (str.to_re "\u{09}"))) (re.++ (str.to_re "K") (re.++ (str.to_re "/") (re.++ (str.to_re "23424977") (re.++ (str.to_re "/") (str.to_re "g"))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)