;test regex [&?]var=((?:%[\dA-Fa-f]{2}|[^&%]){10})(?:&|$)
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (str.to_re "&") (str.to_re "?")) (re.++ (str.to_re "v") (re.++ (str.to_re "a") (re.++ (str.to_re "r") (re.++ (str.to_re "=") (re.++ ((_ re.loop 10 10) (re.union (re.++ (str.to_re "%") ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.union (re.range "A" "F") (re.range "a" "f"))))) (re.inter (re.diff re.allchar (str.to_re "&")) (re.diff re.allchar (str.to_re "%"))))) (re.union (str.to_re "&") (str.to_re ""))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)