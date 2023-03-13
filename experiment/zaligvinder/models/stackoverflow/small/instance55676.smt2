;test regex ".{8},[0-9],[^0-9A-Za-z ],[A-Z],[a-z]"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (re.++ (re.++ (str.to_re "\u{22}") ((_ re.loop 8 8) (re.diff re.allchar (str.to_re "\n")))) (re.++ (str.to_re ",") (re.range "0" "9"))) (re.++ (str.to_re ",") (re.inter (re.diff re.allchar (re.range "0" "9")) (re.inter (re.diff re.allchar (re.range "A" "Z")) (re.inter (re.diff re.allchar (re.range "a" "z")) (re.diff re.allchar (str.to_re " "))))))) (re.++ (str.to_re ",") (re.range "A" "Z"))) (re.++ (str.to_re ",") (re.++ (re.range "a" "z") (str.to_re "\u{22}"))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)