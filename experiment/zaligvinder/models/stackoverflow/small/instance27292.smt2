;test regex [A-Z]{2}&&^(ES|PT|DE)
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ ((_ re.loop 2 2) (re.range "A" "Z")) (re.++ (str.to_re "&") (str.to_re "&"))) (re.++ (str.to_re "") (re.union (re.union (re.++ (str.to_re "E") (str.to_re "S")) (re.++ (str.to_re "P") (str.to_re "T"))) (re.++ (str.to_re "D") (str.to_re "E")))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)