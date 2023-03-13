;test regex ((0?1?2?3?1){1}|(0?1?2?(2|3|4|5|6|7|8|9|0))|(30))\
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.union ((_ re.loop 1 1) (re.++ (re.opt (str.to_re "0")) (re.++ (re.opt (str.to_re "1")) (re.++ (re.opt (str.to_re "2")) (re.++ (re.opt (str.to_re "3")) (str.to_re "1")))))) (re.++ (re.opt (str.to_re "0")) (re.++ (re.opt (str.to_re "1")) (re.++ (re.opt (str.to_re "2")) (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (str.to_re "2") (str.to_re "3")) (str.to_re "4")) (str.to_re "5")) (str.to_re "6")) (str.to_re "7")) (str.to_re "8")) (str.to_re "9")) (str.to_re "0")))))) (str.to_re "30")) (str.to_re "\"))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)