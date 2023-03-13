;test regex ^[1-4]\d{3}\/((0?[1-6]\/((3[0-1])|([1-2][0-9])|(0?[1-9])))|((1[0-2]|(0?[7-9]))\/(30|([1-2][0-9])|(0?[1-9]))))$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.range "1" "4") (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (str.to_re "/") (re.union (re.++ (re.opt (str.to_re "0")) (re.++ (re.range "1" "6") (re.++ (str.to_re "/") (re.union (re.union (re.++ (str.to_re "3") (re.range "0" "1")) (re.++ (re.range "1" "2") (re.range "0" "9"))) (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")))))) (re.++ (re.union (re.++ (str.to_re "1") (re.range "0" "2")) (re.++ (re.opt (str.to_re "0")) (re.range "7" "9"))) (re.++ (str.to_re "/") (re.union (re.union (str.to_re "30") (re.++ (re.range "1" "2") (re.range "0" "9"))) (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)