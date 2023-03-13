;test regex (([aA-zZ]{0,}[0-9]{0,}){3,})\w+
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.* (re.++ (re.++ (re.* (re.union (str.to_re "a") (re.union (re.range "A" "z") (str.to_re "Z")))) ((_ re.loop 0 0) (re.union (str.to_re "a") (re.union (re.range "A" "z") (str.to_re "Z"))))) (re.++ (re.* (re.range "0" "9")) ((_ re.loop 0 0) (re.range "0" "9"))))) ((_ re.loop 3 3) (re.++ (re.++ (re.* (re.union (str.to_re "a") (re.union (re.range "A" "z") (str.to_re "Z")))) ((_ re.loop 0 0) (re.union (str.to_re "a") (re.union (re.range "A" "z") (str.to_re "Z"))))) (re.++ (re.* (re.range "0" "9")) ((_ re.loop 0 0) (re.range "0" "9")))))) (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)