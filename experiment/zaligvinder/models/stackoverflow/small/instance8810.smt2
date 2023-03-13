;test regex (0{0,3}32)(9|8|7|6|5|4|3|2)([0-9]{3})([0-9]{2})([0-9]{2})
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ ((_ re.loop 0 3) (str.to_re "0")) (str.to_re "32")) (re.++ (re.union (re.union (re.union (re.union (re.union (re.union (re.union (str.to_re "9") (str.to_re "8")) (str.to_re "7")) (str.to_re "6")) (str.to_re "5")) (str.to_re "4")) (str.to_re "3")) (str.to_re "2")) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9"))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)