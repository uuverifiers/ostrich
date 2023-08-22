;test regex .*A[^AB]{0,400}[CG][EF]{43,43}G[^DF].*
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "A") (re.++ ((_ re.loop 0 400) (re.inter (re.diff re.allchar (str.to_re "A")) (re.diff re.allchar (str.to_re "B")))) (re.++ (re.union (str.to_re "C") (str.to_re "G")) (re.++ ((_ re.loop 43 43) (re.union (str.to_re "E") (str.to_re "F"))) (re.++ (str.to_re "G") (re.++ (re.inter (re.diff re.allchar (str.to_re "D")) (re.diff re.allchar (str.to_re "F"))) (re.* (re.diff re.allchar (str.to_re "\n"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 200 (str.len X)))
(check-sat)
(get-model)