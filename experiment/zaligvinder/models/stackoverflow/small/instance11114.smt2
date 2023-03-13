;test regex DB(1000|0[1-9]|[1-9]\d{0,2})\.DB[XBDW](1000|0[1-9]|[1-9]\d{0,2})\.(0|10|[1-9])
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "D") (re.++ (str.to_re "B") (re.++ (re.union (re.union (str.to_re "1000") (re.++ (str.to_re "0") (re.range "1" "9"))) (re.++ (re.range "1" "9") ((_ re.loop 0 2) (re.range "0" "9")))) (re.++ (str.to_re ".") (re.++ (str.to_re "D") (re.++ (str.to_re "B") (re.++ (re.union (str.to_re "X") (re.union (str.to_re "B") (re.union (str.to_re "D") (str.to_re "W")))) (re.++ (re.union (re.union (str.to_re "1000") (re.++ (str.to_re "0") (re.range "1" "9"))) (re.++ (re.range "1" "9") ((_ re.loop 0 2) (re.range "0" "9")))) (re.++ (str.to_re ".") (re.union (re.union (str.to_re "0") (str.to_re "10")) (re.range "1" "9")))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)