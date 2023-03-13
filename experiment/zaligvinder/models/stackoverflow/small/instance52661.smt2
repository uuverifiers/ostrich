;test regex (?:(\d{1,2})(?:th|nd|rd).* ([a-z]{3})[a-z]*|([a-z]{3})[a-z]* (\d{1,2})),\s*(\d{4})
(declare-const X String)
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (re.union (re.union (re.++ (str.to_re "t") (str.to_re "h")) (re.++ (str.to_re "n") (str.to_re "d"))) (re.++ (str.to_re "r") (str.to_re "d"))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re " ") (re.++ ((_ re.loop 3 3) (re.range "a" "z")) (re.* (re.range "a" "z"))))))) (re.++ ((_ re.loop 3 3) (re.range "a" "z")) (re.++ (re.* (re.range "a" "z")) (re.++ (str.to_re " ") ((_ re.loop 1 2) (re.range "0" "9")))))) (re.++ (str.to_re ",") (re.++ (re.* (re.union (str.to_re " ") (re.union (str.to_re "\u{0b}") (re.union (str.to_re "\u{0a}") (re.union (str.to_re "\u{0d}") (re.union (str.to_re "\u{09}") (str.to_re "\u{0c}"))))))) ((_ re.loop 4 4) (re.range "0" "9")))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)