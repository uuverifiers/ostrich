;test regex <[a-z1-9]{1,10}>(.*?)<\/[a-z1-9]{1,10}>
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "<") (re.++ ((_ re.loop 1 10) (re.union (re.range "a" "z") (re.range "1" "9"))) (re.++ (str.to_re ">") (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (str.to_re "<") (re.++ (str.to_re "/") (re.++ ((_ re.loop 1 10) (re.union (re.range "a" "z") (re.range "1" "9"))) (str.to_re ">"))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)