;test regex ^ATOM.{15}[GATC]
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (str.to_re "A") (re.++ (str.to_re "T") (re.++ (str.to_re "O") (re.++ (str.to_re "M") (re.++ ((_ re.loop 15 15) (re.diff re.allchar (str.to_re "\n"))) (re.union (str.to_re "G") (re.union (str.to_re "A") (re.union (str.to_re "T") (str.to_re "C"))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)