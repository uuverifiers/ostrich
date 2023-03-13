;test regex 4026.{12}|417500.{10}|4405.{12}|4508.{12}|4844.{12}|4913.{12}|4917.{12}|([4].{12}|[4].{15})
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "4026") ((_ re.loop 12 12) (re.diff re.allchar (str.to_re "\n")))) (re.++ (str.to_re "417500") ((_ re.loop 10 10) (re.diff re.allchar (str.to_re "\n"))))) (re.++ (str.to_re "4405") ((_ re.loop 12 12) (re.diff re.allchar (str.to_re "\n"))))) (re.++ (str.to_re "4508") ((_ re.loop 12 12) (re.diff re.allchar (str.to_re "\n"))))) (re.++ (str.to_re "4844") ((_ re.loop 12 12) (re.diff re.allchar (str.to_re "\n"))))) (re.++ (str.to_re "4913") ((_ re.loop 12 12) (re.diff re.allchar (str.to_re "\n"))))) (re.++ (str.to_re "4917") ((_ re.loop 12 12) (re.diff re.allchar (str.to_re "\n"))))) (re.union (re.++ (str.to_re "4") ((_ re.loop 12 12) (re.diff re.allchar (str.to_re "\n")))) (re.++ (str.to_re "4") ((_ re.loop 15 15) (re.diff re.allchar (str.to_re "\n"))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)