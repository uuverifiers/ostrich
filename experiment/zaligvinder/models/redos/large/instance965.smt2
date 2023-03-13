;test regex .*BA{0,50}(EC|EE)A{0,10}[DE]{86,86}FF.*
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "B") (re.++ ((_ re.loop 0 50) (str.to_re "A")) (re.++ (re.union (re.++ (str.to_re "E") (str.to_re "C")) (re.++ (str.to_re "E") (str.to_re "E"))) (re.++ ((_ re.loop 0 10) (str.to_re "A")) (re.++ ((_ re.loop 86 86) (re.union (str.to_re "D") (str.to_re "E"))) (re.++ (str.to_re "F") (re.++ (str.to_re "F") (re.* (re.diff re.allchar (str.to_re "\n")))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)