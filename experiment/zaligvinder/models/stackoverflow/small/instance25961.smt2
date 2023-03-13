;test regex (.*)([Ss]?[0-9]{1,2}?[Ee]?[0-9]{1,2}?)(.*)
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.++ (re.opt (re.union (str.to_re "S") (str.to_re "s"))) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (re.opt (re.union (str.to_re "E") (str.to_re "e"))) ((_ re.loop 1 2) (re.range "0" "9"))))) (re.* (re.diff re.allchar (str.to_re "\n")))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)