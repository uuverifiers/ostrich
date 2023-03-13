;test regex ([b-oq-z]{1}\.[a-ln-z]{1}|a\.[^m]|p\.[^m]|[a-z]{1}[ap]\.m|[ap]\.m[a-z]+|[b-oq-z]{1}\.m)
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.union (re.union (re.++ ((_ re.loop 1 1) (re.union (re.range "b" "o") (re.range "q" "z"))) (re.++ (str.to_re ".") ((_ re.loop 1 1) (re.union (re.range "a" "l") (re.range "n" "z"))))) (re.++ (str.to_re "a") (re.++ (str.to_re ".") (re.diff re.allchar (str.to_re "m"))))) (re.++ (str.to_re "p") (re.++ (str.to_re ".") (re.diff re.allchar (str.to_re "m"))))) (re.++ ((_ re.loop 1 1) (re.range "a" "z")) (re.++ (re.union (str.to_re "a") (str.to_re "p")) (re.++ (str.to_re ".") (str.to_re "m"))))) (re.++ (re.union (str.to_re "a") (str.to_re "p")) (re.++ (str.to_re ".") (re.++ (str.to_re "m") (re.+ (re.range "a" "z")))))) (re.++ ((_ re.loop 1 1) (re.union (re.range "b" "o") (re.range "q" "z"))) (re.++ (str.to_re ".") (str.to_re "m"))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)