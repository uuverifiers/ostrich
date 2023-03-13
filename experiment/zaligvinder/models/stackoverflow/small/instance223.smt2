;test regex \(\s\w+\s(BINARY\(\d{1,2}\)[^,)])
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "(") (re.++ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) (re.++ (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_"))))) (re.++ (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}")))))) (re.++ (str.to_re "B") (re.++ (str.to_re "I") (re.++ (str.to_re "N") (re.++ (str.to_re "A") (re.++ (str.to_re "R") (re.++ (str.to_re "Y") (re.++ (str.to_re "(") (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (str.to_re ")") (re.inter (re.diff re.allchar (str.to_re ",")) (re.diff re.allchar (str.to_re ")"))))))))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)