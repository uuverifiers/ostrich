;test regex ^(([0][0]|[+])([9][6][1])([0-9]{1}|[7][0]|[7][1]|[7][6]|[7][8]))$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.++ (str.to_re "0") (str.to_re "0")) (str.to_re "+")) (re.++ (re.++ (str.to_re "9") (re.++ (str.to_re "6") (str.to_re "1"))) (re.union (re.union (re.union (re.union ((_ re.loop 1 1) (re.range "0" "9")) (re.++ (str.to_re "7") (str.to_re "0"))) (re.++ (str.to_re "7") (str.to_re "1"))) (re.++ (str.to_re "7") (str.to_re "6"))) (re.++ (str.to_re "7") (str.to_re "8")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)