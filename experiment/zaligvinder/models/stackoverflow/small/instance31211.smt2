;test regex ^(([^f].{2}|.[^o].|.{2}[^o]).*|.{0,2})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.++ (re.union (re.union (re.++ (re.diff re.allchar (str.to_re "f")) ((_ re.loop 2 2) (re.diff re.allchar (str.to_re "\n")))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.diff re.allchar (str.to_re "o")) (re.diff re.allchar (str.to_re "\n"))))) (re.++ ((_ re.loop 2 2) (re.diff re.allchar (str.to_re "\n"))) (re.diff re.allchar (str.to_re "o")))) (re.* (re.diff re.allchar (str.to_re "\n")))) ((_ re.loop 0 2) (re.diff re.allchar (str.to_re "\n"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)