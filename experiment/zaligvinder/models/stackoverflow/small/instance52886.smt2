;test regex ^[a-z](\d\d?|[a-z]\d[a-z\d]?|[a-z]?\d?\d \d[a-z]{2}|[a-z]\d [a-z] \d[a-z]{2})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.range "a" "z") (re.union (re.union (re.union (re.++ (re.range "0" "9") (re.opt (re.range "0" "9"))) (re.++ (re.range "a" "z") (re.++ (re.range "0" "9") (re.opt (re.union (re.range "a" "z") (re.range "0" "9")))))) (re.++ (re.opt (re.range "a" "z")) (re.++ (re.opt (re.range "0" "9")) (re.++ (re.range "0" "9") (re.++ (str.to_re " ") (re.++ (re.range "0" "9") ((_ re.loop 2 2) (re.range "a" "z")))))))) (re.++ (re.range "a" "z") (re.++ (re.range "0" "9") (re.++ (str.to_re " ") (re.++ (re.range "a" "z") (re.++ (str.to_re " ") (re.++ (re.range "0" "9") ((_ re.loop 2 2) (re.range "a" "z"))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)