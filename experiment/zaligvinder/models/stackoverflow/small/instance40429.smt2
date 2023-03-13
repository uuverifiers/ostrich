;test regex (RAM 1000)(?:(?:\/)(\w+)){1,}
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "R") (re.++ (str.to_re "A") (re.++ (str.to_re "M") (re.++ (str.to_re " ") (str.to_re "1000"))))) (re.++ (re.* (re.++ (str.to_re "/") (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))))) ((_ re.loop 1 1) (re.++ (str.to_re "/") (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)