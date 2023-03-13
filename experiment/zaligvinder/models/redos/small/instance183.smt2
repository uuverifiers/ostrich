;test regex &(#[0-9]+|#[xX][0-9a-fA-F]+|[^\t\n\f <&#]{1,32})
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "&") (re.union (re.union (re.++ (str.to_re "#") (re.+ (re.range "0" "9"))) (re.++ (str.to_re "#") (re.++ (re.union (str.to_re "x") (str.to_re "X")) (re.+ (re.union (re.range "0" "9") (re.union (re.range "a" "f") (re.range "A" "F"))))))) ((_ re.loop 1 32) (re.inter (re.diff re.allchar (str.to_re "\u{09}")) (re.inter (re.diff re.allchar (str.to_re "\u{0a}")) (re.inter (re.diff re.allchar (str.to_re "\u{0c}")) (re.inter (re.diff re.allchar (str.to_re " ")) (re.inter (re.diff re.allchar (str.to_re "<")) (re.inter (re.diff re.allchar (str.to_re "&")) (re.diff re.allchar (str.to_re "#")))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)