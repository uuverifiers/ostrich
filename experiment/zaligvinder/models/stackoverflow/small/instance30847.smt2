;test regex (remote:[a-zA-Z]+\|[^\,]+|[a-f0-9]{32})
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "r") (re.++ (str.to_re "e") (re.++ (str.to_re "m") (re.++ (str.to_re "o") (re.++ (str.to_re "t") (re.++ (str.to_re "e") (re.++ (str.to_re ":") (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ (str.to_re "|") (re.+ (re.diff re.allchar (str.to_re ",")))))))))))) ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)