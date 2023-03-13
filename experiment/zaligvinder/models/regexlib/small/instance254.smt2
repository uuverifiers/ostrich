;test regex ^0(6[045679][0469]){1}(\-)?(1)?[^0\D]{1}\d{6}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "0") (re.++ ((_ re.loop 1 1) (re.++ (str.to_re "6") (re.++ (str.to_re "045679") (str.to_re "0469")))) (re.++ (re.opt (str.to_re "-")) (re.++ (re.opt (str.to_re "1")) (re.++ ((_ re.loop 1 1) (re.inter (re.diff re.allchar (str.to_re "0")) (re.diff re.allchar (re.diff re.allchar (re.range "0" "9"))))) ((_ re.loop 6 6) (re.range "0" "9")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)