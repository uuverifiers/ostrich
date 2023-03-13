;test regex (\/ORGNAME(?:\/[\w-]*?){2}[^\/]*$)
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "/") (re.++ (str.to_re "O") (re.++ (str.to_re "R") (re.++ (str.to_re "G") (re.++ (str.to_re "N") (re.++ (str.to_re "A") (re.++ (str.to_re "M") (re.++ (str.to_re "E") (re.++ ((_ re.loop 2 2) (re.++ (str.to_re "/") (re.* (re.union (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "_")))) (str.to_re "-"))))) (re.* (re.diff re.allchar (str.to_re "/")))))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)