;test regex ^((\+92)|(0092))-{0,1}\d{3}-{0,1}\d{7}$|^\d{11}$|^\d{4}-\d{7}$
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.++ (str.to_re "+") (str.to_re "92")) (str.to_re "0092")) (re.++ ((_ re.loop 0 1) (str.to_re "-")) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ ((_ re.loop 0 1) (str.to_re "-")) ((_ re.loop 7 7) (re.range "0" "9"))))))) (str.to_re "")) (re.++ (re.++ (str.to_re "") ((_ re.loop 11 11) (re.range "0" "9"))) (str.to_re ""))) (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.++ (str.to_re "-") ((_ re.loop 7 7) (re.range "0" "9"))))) (str.to_re "")))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)