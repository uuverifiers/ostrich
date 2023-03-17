;test regex [+-]?[0-9]+([\.][0-9]{0,2})[TRS][trs][PBC][pbc]?
(declare-const X String)
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.++ (re.+ (re.range "0" "9")) (re.++ (re.++ (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9"))) (re.++ (re.union (str.to_re "T") (re.union (str.to_re "R") (str.to_re "S"))) (re.++ (re.union (str.to_re "t") (re.union (str.to_re "r") (str.to_re "s"))) (re.++ (re.union (str.to_re "P") (re.union (str.to_re "B") (str.to_re "C"))) (re.opt (re.union (str.to_re "p") (re.union (str.to_re "b") (str.to_re "c"))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)