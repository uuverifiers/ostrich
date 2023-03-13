;test regex ^[a-z0-9]+(.[_a-z0-9]+)*@[a-z0-9](.[a-z0-9]).(.[a-z]{3,15})
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (re.++ (re.* (re.++ (re.diff re.allchar (str.to_re "\n")) (re.+ (re.union (str.to_re "_") (re.union (re.range "a" "z") (re.range "0" "9")))))) (re.++ (str.to_re "@") (re.++ (re.union (re.range "a" "z") (re.range "0" "9")) (re.++ (re.++ (re.diff re.allchar (str.to_re "\n")) (re.union (re.range "a" "z") (re.range "0" "9"))) (re.++ (re.diff re.allchar (str.to_re "\n")) (re.++ (re.diff re.allchar (str.to_re "\n")) ((_ re.loop 3 15) (re.range "a" "z"))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)