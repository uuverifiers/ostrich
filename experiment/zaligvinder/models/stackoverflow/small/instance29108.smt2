;test regex [^\w\\d]*(([0-9]+.*[A-Za-z]{3}.*)|[A-Za-z]+.*([0-9]+.*))
(declare-const X String)
(assert (str.in_re X (re.++ (re.* (re.inter (re.diff re.allchar (re.range "a" "z")) (re.inter (re.diff re.allchar (re.range "A" "Z")) (re.inter (re.diff re.allchar (re.range "0" "9")) (re.inter (re.diff re.allchar (str.to_re "_")) (re.inter (re.diff re.allchar (str.to_re "\\")) (re.diff re.allchar (str.to_re "d")))))))) (re.union (re.++ (re.+ (re.range "0" "9")) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ ((_ re.loop 3 3) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.* (re.diff re.allchar (str.to_re "\n")))))) (re.++ (re.+ (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.++ (re.* (re.diff re.allchar (str.to_re "\n"))) (re.++ (re.+ (re.range "0" "9")) (re.* (re.diff re.allchar (str.to_re "\n"))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)