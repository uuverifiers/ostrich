;test regex (10|01|(11)+(10|0[10])|(00)+(01|1[10]))([10]{2})*
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.union (re.union (str.to_re "10") (str.to_re "01")) (re.++ (re.+ (str.to_re "11")) (re.union (str.to_re "10") (re.++ (str.to_re "0") (str.to_re "10"))))) (re.++ (re.+ (str.to_re "00")) (re.union (str.to_re "01") (re.++ (str.to_re "1") (str.to_re "10"))))) (re.* ((_ re.loop 2 2) (str.to_re "10"))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)