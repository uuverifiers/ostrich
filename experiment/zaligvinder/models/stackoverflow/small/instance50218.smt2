;test regex ^[A-Z]{6}-[A-Z]{4}-[A-Z]{4}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 6 6) (re.range "A" "Z")) (re.++ (str.to_re "-") (re.++ ((_ re.loop 4 4) (re.range "A" "Z")) (re.++ (str.to_re "-") ((_ re.loop 4 4) (re.range "A" "Z"))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)