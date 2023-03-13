;test regex ^([IZ][A-Z]{0,2}|[A-Z]([IZ][A-Z]?|[A-Z][IZ]))[0-9]{1,4}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (re.++ (re.union (str.to_re "I") (str.to_re "Z")) ((_ re.loop 0 2) (re.range "A" "Z"))) (re.++ (re.range "A" "Z") (re.union (re.++ (re.union (str.to_re "I") (str.to_re "Z")) (re.opt (re.range "A" "Z"))) (re.++ (re.range "A" "Z") (re.union (str.to_re "I") (str.to_re "Z")))))) ((_ re.loop 1 4) (re.range "0" "9")))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)