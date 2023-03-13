;test regex (1[0-9]{0,2}|2[0-9]{0,1}|2[0-4][0-9]|25[0-5]|[3-9][0-9]?)(\.(0|1[0-9]{0,2}|2[0-9]{0,1}|2[0-4][0-9]|25[0-5]|[3-9][0-9]?)){3}
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.union (re.union (re.union (re.++ (str.to_re "1") ((_ re.loop 0 2) (re.range "0" "9"))) (re.++ (str.to_re "2") ((_ re.loop 0 1) (re.range "0" "9")))) (re.++ (str.to_re "2") (re.++ (re.range "0" "4") (re.range "0" "9")))) (re.++ (str.to_re "25") (re.range "0" "5"))) (re.++ (re.range "3" "9") (re.opt (re.range "0" "9")))) ((_ re.loop 3 3) (re.++ (str.to_re ".") (re.union (re.union (re.union (re.union (re.union (str.to_re "0") (re.++ (str.to_re "1") ((_ re.loop 0 2) (re.range "0" "9")))) (re.++ (str.to_re "2") ((_ re.loop 0 1) (re.range "0" "9")))) (re.++ (str.to_re "2") (re.++ (re.range "0" "4") (re.range "0" "9")))) (re.++ (str.to_re "25") (re.range "0" "5"))) (re.++ (re.range "3" "9") (re.opt (re.range "0" "9")))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)