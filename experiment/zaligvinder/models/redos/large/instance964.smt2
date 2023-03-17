;test regex .*BA{0,50}(FD|FF)A{0,10}[E-G]{43,43}H[^CG].*
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "B") (re.++ ((_ re.loop 0 50) (str.to_re "A")) (re.++ (re.union (re.++ (str.to_re "F") (str.to_re "D")) (re.++ (str.to_re "F") (str.to_re "F"))) (re.++ ((_ re.loop 0 10) (str.to_re "A")) (re.++ ((_ re.loop 43 43) (re.range "E" "G")) (re.++ (str.to_re "H") (re.++ (re.inter (re.diff re.allchar (str.to_re "C")) (re.diff re.allchar (str.to_re "G"))) (re.* (re.diff re.allchar (str.to_re "\n")))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)