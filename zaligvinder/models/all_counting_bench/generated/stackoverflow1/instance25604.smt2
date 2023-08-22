;test regex (\d{4})?(jan|feb|...)(\d{4})?
(declare-const X String)
(assert (str.in_re X (re.++ (re.opt ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (re.union (re.union (re.++ (str.to_re "j") (re.++ (str.to_re "a") (str.to_re "n"))) (re.++ (str.to_re "f") (re.++ (str.to_re "e") (str.to_re "b")))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.diff re.allchar (str.to_re "\n"))))) (re.opt ((_ re.loop 4 4) (re.range "0" "9")))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)