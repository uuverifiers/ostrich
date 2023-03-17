;test regex .*A[^AB]{0,800}C[D-G]{43,53}DFG[^D-H].*
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "A") (re.++ ((_ re.loop 0 800) (re.inter (re.diff re.allchar (str.to_re "A")) (re.diff re.allchar (str.to_re "B")))) (re.++ (str.to_re "C") (re.++ ((_ re.loop 43 53) (re.range "D" "G")) (re.++ (str.to_re "D") (re.++ (str.to_re "F") (re.++ (str.to_re "G") (re.++ (re.diff re.allchar (re.range "D" "H")) (re.* (re.diff re.allchar (str.to_re "\n"))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)