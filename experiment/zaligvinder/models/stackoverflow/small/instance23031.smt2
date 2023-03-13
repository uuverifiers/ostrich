;test regex .?(AT[0-9]{10})|(BE[0-9]{10})|(FR[0-9]{10})|(IT[0-9]{10})
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.++ (re.opt (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "A") (re.++ (str.to_re "T") ((_ re.loop 10 10) (re.range "0" "9"))))) (re.++ (str.to_re "B") (re.++ (str.to_re "E") ((_ re.loop 10 10) (re.range "0" "9"))))) (re.++ (str.to_re "F") (re.++ (str.to_re "R") ((_ re.loop 10 10) (re.range "0" "9"))))) (re.++ (str.to_re "I") (re.++ (str.to_re "T") ((_ re.loop 10 10) (re.range "0" "9")))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)