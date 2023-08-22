;test regex [AB]{2}(...)[AB]{2}
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.union (str.to_re "A") (str.to_re "B"))) (re.++ (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.diff re.allchar (str.to_re "\n")))) ((_ re.loop 2 2) (re.union (str.to_re "A") (str.to_re "B")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)