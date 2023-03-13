;test regex /http:\/\/[a-zA-Z]{3}\.[a-zA-Z]{2}\/[a-zA-Z]{7}\/[a-zA-Z]{6}\/\d{12}/
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "/") (re.++ (str.to_re "h") (re.++ (str.to_re "t") (re.++ (str.to_re "t") (re.++ (str.to_re "p") (re.++ (str.to_re ":") (re.++ (str.to_re "/") (re.++ (str.to_re "/") (re.++ ((_ re.loop 3 3) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ (str.to_re ".") (re.++ ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ (str.to_re "/") (re.++ ((_ re.loop 7 7) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ (str.to_re "/") (re.++ ((_ re.loop 6 6) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ (str.to_re "/") (re.++ ((_ re.loop 12 12) (re.range "0" "9")) (str.to_re "/"))))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)