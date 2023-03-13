;test regex ^([A-Z]{2,2}[-]{1,1}[A-Z]{2,2}[0-9]{14,14}[A-Z]{1,1}){1,1}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") ((_ re.loop 1 1) (re.++ ((_ re.loop 2 2) (re.range "A" "Z")) (re.++ ((_ re.loop 1 1) (str.to_re "-")) (re.++ ((_ re.loop 2 2) (re.range "A" "Z")) (re.++ ((_ re.loop 14 14) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "A" "Z")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)