;test regex (A[^\r\n]{50}(\r\n|\n))(B[^\r\n]{50}(\r\n|\n))+
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "A") (re.++ ((_ re.loop 50 50) (re.inter (re.diff re.allchar (str.to_re "\u{0d}")) (re.diff re.allchar (str.to_re "\u{0a}")))) (re.union (re.++ (str.to_re "\u{0d}") (str.to_re "\u{0a}")) (str.to_re "\u{0a}")))) (re.+ (re.++ (str.to_re "B") (re.++ ((_ re.loop 50 50) (re.inter (re.diff re.allchar (str.to_re "\u{0d}")) (re.diff re.allchar (str.to_re "\u{0a}")))) (re.union (re.++ (str.to_re "\u{0d}") (str.to_re "\u{0a}")) (str.to_re "\u{0a}"))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)