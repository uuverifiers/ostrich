;test regex ([a-zA-Z0-9_]{1,}) ([a-zA-Z]{1,}(?:\([0-9,]{1,7}[0-9]{0,}\))|(?:,))(.*)
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.* (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))))) (re.++ (str.to_re " ") (re.++ (re.union (re.++ (re.++ (re.* (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.range "A" "Z")))) (re.++ (str.to_re "(") (re.++ ((_ re.loop 1 7) (re.union (re.range "0" "9") (str.to_re ","))) (re.++ (re.++ (re.* (re.range "0" "9")) ((_ re.loop 0 0) (re.range "0" "9"))) (str.to_re ")"))))) (str.to_re ",")) (re.* (re.diff re.allchar (str.to_re "\n"))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)