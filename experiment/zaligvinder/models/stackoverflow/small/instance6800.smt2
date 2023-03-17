;test regex ([A-Z]{5}[0-9]{4}[A-Z])(XM|XD|EM|ED)([0-9]{3})(_PRA_)([0-9]{3})
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ ((_ re.loop 5 5) (re.range "A" "Z")) (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.range "A" "Z"))) (re.++ (re.union (re.union (re.union (re.++ (str.to_re "X") (str.to_re "M")) (re.++ (str.to_re "X") (str.to_re "D"))) (re.++ (str.to_re "E") (str.to_re "M"))) (re.++ (str.to_re "E") (str.to_re "D"))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (re.++ (str.to_re "_") (re.++ (str.to_re "P") (re.++ (str.to_re "R") (re.++ (str.to_re "A") (str.to_re "_"))))) ((_ re.loop 3 3) (re.range "0" "9"))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)