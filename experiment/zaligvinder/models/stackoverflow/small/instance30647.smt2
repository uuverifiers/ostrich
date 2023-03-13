;test regex ^(?:(?:\d{1,2}|1[0-8]\d)(?:\.\d+)?|190(?:\.0+)?)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.++ (re.union ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (str.to_re "1") (re.++ (re.range "0" "8") (re.range "0" "9")))) (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9"))))) (re.++ (str.to_re "190") (re.opt (re.++ (str.to_re ".") (re.+ (str.to_re "0"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)