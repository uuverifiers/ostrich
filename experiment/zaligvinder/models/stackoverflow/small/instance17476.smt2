;test regex 1.{1}|2.{2}|3.{3}|4.{4}
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.++ (str.to_re "1") ((_ re.loop 1 1) (re.diff re.allchar (str.to_re "\n")))) (re.++ (str.to_re "2") ((_ re.loop 2 2) (re.diff re.allchar (str.to_re "\n"))))) (re.++ (str.to_re "3") ((_ re.loop 3 3) (re.diff re.allchar (str.to_re "\n"))))) (re.++ (str.to_re "4") ((_ re.loop 4 4) (re.diff re.allchar (str.to_re "\n")))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)