;test regex [A-Za-z]{2}[A-Za-z]*[ ]?[A-Za-z]*
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.++ (re.* (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.++ (re.opt (str.to_re " ")) (re.* (re.union (re.range "A" "Z") (re.range "a" "z"))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)