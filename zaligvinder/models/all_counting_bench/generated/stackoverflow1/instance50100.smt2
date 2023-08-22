;test regex (?:TRS|PCB|[+-]?999|[-+]?(?:(?:[1-8]\d{2}|9\d[1-8]|[1-9]\d|\d)?(?:\.(?:0[1-9]|[1-9]\d|[1-9]))?))
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.++ (str.to_re "T") (re.++ (str.to_re "R") (str.to_re "S"))) (re.++ (str.to_re "P") (re.++ (str.to_re "C") (str.to_re "B")))) (re.++ (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (str.to_re "999"))) (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "+"))) (re.++ (re.opt (re.union (re.union (re.union (re.++ (re.range "1" "8") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "9") (re.++ (re.range "0" "9") (re.range "1" "8")))) (re.++ (re.range "1" "9") (re.range "0" "9"))) (re.range "0" "9"))) (re.opt (re.++ (str.to_re ".") (re.union (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.range "1" "9") (re.range "0" "9"))) (re.range "1" "9")))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)