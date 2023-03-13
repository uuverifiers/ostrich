;test regex ^([a-zA-Z\\d]?\\d{4}|[a-zA-Z]{3}\\d{2}|[a-zA-Z]\\d{4}[a-zA-Z])$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union (re.++ (re.opt (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (str.to_re "\\") (str.to_re "d"))))) (re.++ (str.to_re "\\") ((_ re.loop 4 4) (str.to_re "d")))) (re.++ ((_ re.loop 3 3) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ (str.to_re "\\") ((_ re.loop 2 2) (str.to_re "d"))))) (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (re.++ (str.to_re "\\") (re.++ ((_ re.loop 4 4) (str.to_re "d")) (re.union (re.range "a" "z") (re.range "A" "Z"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)