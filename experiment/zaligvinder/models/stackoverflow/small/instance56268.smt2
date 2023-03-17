;test regex (^2\d{0,8}$)|(^(3[125689]|4[16789]|5[0-9]|60)\d{0,7}$)
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "2") ((_ re.loop 0 8) (re.range "0" "9")))) (str.to_re "")) (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.union (re.union (re.++ (str.to_re "3") (str.to_re "125689")) (re.++ (str.to_re "4") (str.to_re "16789"))) (re.++ (str.to_re "5") (re.range "0" "9"))) (str.to_re "60")) ((_ re.loop 0 7) (re.range "0" "9")))) (str.to_re "")))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)