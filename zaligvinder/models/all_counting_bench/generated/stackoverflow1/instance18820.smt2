;test regex ((00966|966|\+966|05|5|9|0)(5|8|9)|8\d)([0-9]{7,18})
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.++ (re.union (re.union (re.union (re.union (re.union (re.union (str.to_re "00966") (str.to_re "966")) (re.++ (str.to_re "+") (str.to_re "966"))) (str.to_re "05")) (str.to_re "5")) (str.to_re "9")) (str.to_re "0")) (re.union (re.union (str.to_re "5") (str.to_re "8")) (str.to_re "9"))) (re.++ (str.to_re "8") (re.range "0" "9"))) ((_ re.loop 7 18) (re.range "0" "9")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)