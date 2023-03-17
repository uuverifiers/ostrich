;test regex \A[+-]?(180|(1[0-7][0-9]|[0-9]{1,2})([.,][0-9]+)?)\z
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "A") (re.++ (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.++ (re.union (str.to_re "180") (re.++ (re.union (re.++ (str.to_re "1") (re.++ (re.range "0" "7") (re.range "0" "9"))) ((_ re.loop 1 2) (re.range "0" "9"))) (re.opt (re.++ (re.union (str.to_re ".") (str.to_re ",")) (re.+ (re.range "0" "9")))))) (str.to_re "z"))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)