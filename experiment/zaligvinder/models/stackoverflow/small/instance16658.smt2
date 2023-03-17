;test regex ^(.{0,5}|.*([^-].{5}|-([^C].{4}|C([^O].{3}|O([^N].{2}|N([^S].|S[^T]))))))$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union ((_ re.loop 0 5) (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.union (re.++ (re.diff re.allchar (str.to_re "-")) ((_ re.loop 5 5) (re.diff re.allchar (str.to_re "\n")))) (re.++ (str.to_re "-") (re.union (re.++ (re.diff re.allchar (str.to_re "C")) ((_ re.loop 4 4) (re.diff re.allchar (str.to_re "\n")))) (re.++ (str.to_re "C") (re.union (re.++ (re.diff re.allchar (str.to_re "O")) ((_ re.loop 3 3) (re.diff re.allchar (str.to_re "\n")))) (re.++ (str.to_re "O") (re.union (re.++ (re.diff re.allchar (str.to_re "N")) ((_ re.loop 2 2) (re.diff re.allchar (str.to_re "\n")))) (re.++ (str.to_re "N") (re.union (re.++ (re.diff re.allchar (str.to_re "S")) (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "S") (re.diff re.allchar (str.to_re "T"))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)