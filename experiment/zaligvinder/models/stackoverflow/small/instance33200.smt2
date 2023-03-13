;test regex (^\+)(\D\d\d\d)(\w{1,13})(\d)(\/)(\d{5}|\$)(\w{0,13})\D\d\d\w$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "") (str.to_re "+")) (re.++ (re.++ (re.diff re.allchar (re.range "0" "9")) (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.range "0" "9")))) (re.++ ((_ re.loop 1 13) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (re.++ (re.range "0" "9") (re.++ (str.to_re "/") (re.++ (re.union ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "$")) (re.++ ((_ re.loop 0 13) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (re.++ (re.diff re.allchar (re.range "0" "9")) (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)