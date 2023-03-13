;test regex ^0(?:8(?:1(?:[789][0-9]{0,8})?|3(?:[1238][0-9]{0,8})?|5(?:9[0-9]{0,8})?|7(?:[78][0-9]{0,8})?)?)?$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "0") (re.opt (re.++ (str.to_re "8") (re.opt (re.union (re.union (re.union (re.++ (str.to_re "1") (re.opt (re.++ (str.to_re "789") ((_ re.loop 0 8) (re.range "0" "9"))))) (re.++ (str.to_re "3") (re.opt (re.++ (str.to_re "1238") ((_ re.loop 0 8) (re.range "0" "9")))))) (re.++ (str.to_re "5") (re.opt (re.++ (str.to_re "9") ((_ re.loop 0 8) (re.range "0" "9")))))) (re.++ (str.to_re "7") (re.opt (re.++ (str.to_re "78") ((_ re.loop 0 8) (re.range "0" "9"))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)