;test regex "fu:([^A-Z" ](?:[^A-Z"]{0,48}[^A-Z" ])?)"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (str.to_re "f") (re.++ (str.to_re "u") (re.++ (str.to_re ":") (re.++ (re.++ (re.inter (re.diff re.allchar (re.range "A" "Z")) (re.inter (re.diff re.allchar (str.to_re "\u{22}")) (re.diff re.allchar (str.to_re " ")))) (re.opt (re.++ ((_ re.loop 0 48) (re.inter (re.diff re.allchar (re.range "A" "Z")) (re.diff re.allchar (str.to_re "\u{22}")))) (re.inter (re.diff re.allchar (re.range "A" "Z")) (re.inter (re.diff re.allchar (str.to_re "\u{22}")) (re.diff re.allchar (str.to_re " "))))))) (str.to_re "\u{22}"))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)