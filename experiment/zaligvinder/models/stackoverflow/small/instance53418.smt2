;test regex ^ip=(\d+(?:\.\d+){3})[\r\n]+userAgent=(.+)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "i") (re.++ (str.to_re "p") (re.++ (str.to_re "=") (re.++ (re.++ (re.+ (re.range "0" "9")) ((_ re.loop 3 3) (re.++ (str.to_re ".") (re.+ (re.range "0" "9"))))) (re.++ (re.+ (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (re.++ (str.to_re "u") (re.++ (str.to_re "s") (re.++ (str.to_re "e") (re.++ (str.to_re "r") (re.++ (str.to_re "A") (re.++ (str.to_re "g") (re.++ (str.to_re "e") (re.++ (str.to_re "n") (re.++ (str.to_re "t") (re.++ (str.to_re "=") (re.+ (re.diff re.allchar (str.to_re "\n"))))))))))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)