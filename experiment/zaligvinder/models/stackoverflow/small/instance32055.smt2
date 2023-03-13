;test regex "([A-Za-z]{12}|[A-Za-z]{6}|[A-Za-z]{3,4})"
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.++ (re.union (re.union ((_ re.loop 12 12) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 6 6) (re.union (re.range "A" "Z") (re.range "a" "z")))) ((_ re.loop 3 4) (re.union (re.range "A" "Z") (re.range "a" "z")))) (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)