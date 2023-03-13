;test regex ^(([A-Z a-z]*)(?:XLS.|PDF.)(\d{8})(.pdf|.xls))
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.* (re.union (re.range "A" "Z") (re.union (str.to_re " ") (re.range "a" "z")))) (re.++ (re.union (re.++ (str.to_re "X") (re.++ (str.to_re "L") (re.++ (str.to_re "S") (re.diff re.allchar (str.to_re "\n"))))) (re.++ (str.to_re "P") (re.++ (str.to_re "D") (re.++ (str.to_re "F") (re.diff re.allchar (str.to_re "\n")))))) (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (re.union (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "p") (re.++ (str.to_re "d") (str.to_re "f")))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (str.to_re "x") (re.++ (str.to_re "l") (str.to_re "s")))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)