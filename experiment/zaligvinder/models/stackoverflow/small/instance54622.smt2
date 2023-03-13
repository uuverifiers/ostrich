;test regex ^(\(?\+?(44|0{1}|0{2}4{2})[1-9]{1}[0-9]{9}\)?)?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.opt (re.++ (re.opt (str.to_re "(")) (re.++ (re.opt (str.to_re "+")) (re.++ (re.union (re.union (str.to_re "44") ((_ re.loop 1 1) (str.to_re "0"))) (re.++ ((_ re.loop 2 2) (str.to_re "0")) ((_ re.loop 2 2) (str.to_re "4")))) (re.++ ((_ re.loop 1 1) (re.range "1" "9")) (re.++ ((_ re.loop 9 9) (re.range "0" "9")) (re.opt (str.to_re ")"))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)