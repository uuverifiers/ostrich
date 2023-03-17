;test regex .*;BYDAY=(?:([+-]?[0-9]*)([A-Z]{2}),?)*.*
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re ";") (re.++ (str.to_re "B") (re.++ (str.to_re "Y") (re.++ (str.to_re "D") (re.++ (str.to_re "A") (re.++ (str.to_re "Y") (re.++ (str.to_re "=") (re.++ (re.* (re.++ (re.++ (re.++ (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.* (re.range "0" "9"))) ((_ re.loop 2 2) (re.range "A" "Z"))) (re.opt (str.to_re ",")))) (re.* (re.diff re.allchar (str.to_re "\n"))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)