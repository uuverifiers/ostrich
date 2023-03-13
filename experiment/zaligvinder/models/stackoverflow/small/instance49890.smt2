;test regex ^A.{2,}[^XYZ][XYZ]$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "A") (re.++ (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) ((_ re.loop 2 2) (re.diff re.allchar (str.to_re "\n")))) (re.++ (re.inter (re.diff re.allchar (str.to_re "X")) (re.inter (re.diff re.allchar (str.to_re "Y")) (re.diff re.allchar (str.to_re "Z")))) (re.union (str.to_re "X") (re.union (str.to_re "Y") (str.to_re "Z"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)