;test regex ^\[([0-9a-fA-F]{1,4})(\:{1,2})([0-9a-fA-F]{1,4})(\:{1,2})([0-9a-fA-F]{1,4})(\:{1,2})([0-9a-fA-F]{1,4})(\:{1,2})([0-9a-fA-F]{1,4})\]
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (str.to_re "[") (re.++ ((_ re.loop 1 4) (re.union (re.range "0" "9") (re.union (re.range "a" "f") (re.range "A" "F")))) (re.++ ((_ re.loop 1 2) (str.to_re ":")) (re.++ ((_ re.loop 1 4) (re.union (re.range "0" "9") (re.union (re.range "a" "f") (re.range "A" "F")))) (re.++ ((_ re.loop 1 2) (str.to_re ":")) (re.++ ((_ re.loop 1 4) (re.union (re.range "0" "9") (re.union (re.range "a" "f") (re.range "A" "F")))) (re.++ ((_ re.loop 1 2) (str.to_re ":")) (re.++ ((_ re.loop 1 4) (re.union (re.range "0" "9") (re.union (re.range "a" "f") (re.range "A" "F")))) (re.++ ((_ re.loop 1 2) (str.to_re ":")) (re.++ ((_ re.loop 1 4) (re.union (re.range "0" "9") (re.union (re.range "a" "f") (re.range "A" "F")))) (str.to_re "]"))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)