;test regex (COT|MED)[ABCD]?-?[0-9]{1,4}(([JK]+[0-9]*)|(\ [A-Z]+)?)
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "C") (re.++ (str.to_re "O") (str.to_re "T"))) (re.++ (str.to_re "M") (re.++ (str.to_re "E") (str.to_re "D")))) (re.++ (re.opt (re.union (str.to_re "A") (re.union (str.to_re "B") (re.union (str.to_re "C") (str.to_re "D"))))) (re.++ (re.opt (str.to_re "-")) (re.++ ((_ re.loop 1 4) (re.range "0" "9")) (re.union (re.++ (re.+ (re.union (str.to_re "J") (str.to_re "K"))) (re.* (re.range "0" "9"))) (re.opt (re.++ (str.to_re " ") (re.+ (re.range "A" "Z")))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)