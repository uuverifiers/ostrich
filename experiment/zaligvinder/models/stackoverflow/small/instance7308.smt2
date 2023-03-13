;test regex ^((07|00447|\+447)\d{9}|(08|003538|\+3538)\d{8,9})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.++ (re.union (re.union (str.to_re "07") (str.to_re "00447")) (re.++ (str.to_re "+") (str.to_re "447"))) ((_ re.loop 9 9) (re.range "0" "9"))) (re.++ (re.union (re.union (str.to_re "08") (str.to_re "003538")) (re.++ (str.to_re "+") (str.to_re "3538"))) ((_ re.loop 8 9) (re.range "0" "9"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)