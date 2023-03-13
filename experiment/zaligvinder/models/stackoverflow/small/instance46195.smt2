;test regex ^2[7-9]|[3-9][9-9]|[1-9][0-9]{2}|[1-8][0-9]{3}|90[0-6][0-9]|907[0-6]$
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "") (re.++ (str.to_re "2") (re.range "7" "9"))) (re.++ (re.range "3" "9") (re.range "9" "9"))) (re.++ (re.range "1" "9") ((_ re.loop 2 2) (re.range "0" "9")))) (re.++ (re.range "1" "8") ((_ re.loop 3 3) (re.range "0" "9")))) (re.++ (str.to_re "90") (re.++ (re.range "0" "6") (re.range "0" "9")))) (re.++ (re.++ (str.to_re "907") (re.range "0" "6")) (str.to_re "")))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)