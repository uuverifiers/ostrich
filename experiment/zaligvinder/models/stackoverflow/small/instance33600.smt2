;test regex [ABC]{1,3}.{0,2}[DEFG].{2,3}V
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 1 3) (re.union (str.to_re "A") (re.union (str.to_re "B") (str.to_re "C")))) (re.++ ((_ re.loop 0 2) (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.union (str.to_re "D") (re.union (str.to_re "E") (re.union (str.to_re "F") (str.to_re "G")))) (re.++ ((_ re.loop 2 3) (re.diff re.allchar (str.to_re "\n"))) (str.to_re "V")))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)