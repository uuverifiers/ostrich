;test regex \-?(90|[0-8]?[0-9]\.[0-9]{0,6})\,\-?(180|(1[0-7][0-9]|[0-9]{0,2})\.[0-9]{0,6})
(declare-const X String)
(assert (str.in_re X (re.++ (re.opt (str.to_re "-")) (re.++ (re.union (str.to_re "90") (re.++ (re.opt (re.range "0" "8")) (re.++ (re.range "0" "9") (re.++ (str.to_re ".") ((_ re.loop 0 6) (re.range "0" "9")))))) (re.++ (str.to_re ",") (re.++ (re.opt (str.to_re "-")) (re.union (str.to_re "180") (re.++ (re.union (re.++ (str.to_re "1") (re.++ (re.range "0" "7") (re.range "0" "9"))) ((_ re.loop 0 2) (re.range "0" "9"))) (re.++ (str.to_re ".") ((_ re.loop 0 6) (re.range "0" "9")))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)