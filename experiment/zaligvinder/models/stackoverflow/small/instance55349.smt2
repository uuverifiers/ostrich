;test regex ^(.{0,3}$|[^m]|.[^p]|..[^e]|...[^g])
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.union (re.union (re.union (re.union (re.++ ((_ re.loop 0 3) (re.diff re.allchar (str.to_re "\n"))) (str.to_re "")) (re.diff re.allchar (str.to_re "m"))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.diff re.allchar (str.to_re "p")))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.diff re.allchar (str.to_re "e"))))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.diff re.allchar (str.to_re "g")))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)