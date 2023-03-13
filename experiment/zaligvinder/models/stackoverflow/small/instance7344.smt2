;test regex ([1]?[0-9])|((20)|(21)|(22)|(23)|(24)){0,1}([.][0-9]{0,2})?
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (re.opt (str.to_re "1")) (re.range "0" "9")) (re.++ ((_ re.loop 0 1) (re.union (re.union (re.union (re.union (str.to_re "20") (str.to_re "21")) (str.to_re "22")) (str.to_re "23")) (str.to_re "24"))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9"))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)