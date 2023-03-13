;test regex Tom.{10,25}river|river.{10,25}Tom
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "T") (re.++ (str.to_re "o") (re.++ (str.to_re "m") (re.++ ((_ re.loop 10 25) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "v") (re.++ (str.to_re "e") (str.to_re "r"))))))))) (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "v") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ ((_ re.loop 10 25) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "T") (re.++ (str.to_re "o") (str.to_re "m"))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)