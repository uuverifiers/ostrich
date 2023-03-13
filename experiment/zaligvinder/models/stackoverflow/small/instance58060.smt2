;test regex ^#?\\b[a-zA-Z]+\\-[0-9]{10,10}\\.[xml]{3,3}\\b$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.opt (str.to_re "#")) (re.++ (str.to_re "\\") (re.++ (str.to_re "b") (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ (str.to_re "\\") (re.++ (str.to_re "-") (re.++ ((_ re.loop 10 10) (re.range "0" "9")) (re.++ (str.to_re "\\") (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ ((_ re.loop 3 3) (re.union (str.to_re "x") (re.union (str.to_re "m") (str.to_re "l")))) (re.++ (str.to_re "\\") (str.to_re "b"))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)