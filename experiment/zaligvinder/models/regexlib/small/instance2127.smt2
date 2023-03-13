;test regex [-]?[1-9]\d{0,16}\.?\d{0,2}|[-]?[0]?\.[1-9]{1,2}|[-]?[0]?\.[0-9][1-9]
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (re.opt (str.to_re "-")) (re.++ (re.range "1" "9") (re.++ ((_ re.loop 0 16) (re.range "0" "9")) (re.++ (re.opt (str.to_re ".")) ((_ re.loop 0 2) (re.range "0" "9")))))) (re.++ (re.opt (str.to_re "-")) (re.++ (re.opt (str.to_re "0")) (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "1" "9")))))) (re.++ (re.opt (str.to_re "-")) (re.++ (re.opt (str.to_re "0")) (re.++ (str.to_re ".") (re.++ (re.range "0" "9") (re.range "1" "9"))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)