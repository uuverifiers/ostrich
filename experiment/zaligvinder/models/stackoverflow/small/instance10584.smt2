;test regex [^OLD_PASSWORD]{4}
(declare-const X String)
(assert (str.in_re X ((_ re.loop 4 4) (re.inter (re.diff re.allchar (str.to_re "O")) (re.inter (re.diff re.allchar (str.to_re "L")) (re.inter (re.diff re.allchar (str.to_re "D")) (re.inter (re.diff re.allchar (str.to_re "_")) (re.inter (re.diff re.allchar (str.to_re "P")) (re.inter (re.diff re.allchar (str.to_re "A")) (re.inter (re.diff re.allchar (str.to_re "S")) (re.inter (re.diff re.allchar (str.to_re "S")) (re.inter (re.diff re.allchar (str.to_re "W")) (re.inter (re.diff re.allchar (str.to_re "O")) (re.inter (re.diff re.allchar (str.to_re "R")) (re.diff re.allchar (str.to_re "D"))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)