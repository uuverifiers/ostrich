;test regex [^@]+@[a-zA-Z]{4}\.(com|co\.uk|co\.za)
(declare-const X String)
(assert (str.in_re X (re.++ (re.+ (re.diff re.allchar (str.to_re "@"))) (re.++ (str.to_re "@") (re.++ ((_ re.loop 4 4) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ (str.to_re ".") (re.union (re.union (re.++ (str.to_re "c") (re.++ (str.to_re "o") (str.to_re "m"))) (re.++ (str.to_re "c") (re.++ (str.to_re "o") (re.++ (str.to_re ".") (re.++ (str.to_re "u") (str.to_re "k")))))) (re.++ (str.to_re "c") (re.++ (str.to_re "o") (re.++ (str.to_re ".") (re.++ (str.to_re "z") (str.to_re "a"))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)