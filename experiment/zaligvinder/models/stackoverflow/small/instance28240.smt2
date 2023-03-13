;test regex ^[A-Z](\d{0,9}$|\d{9}([A-Z]{0,6}$|[A-Z]{6}(\d{0,2}$|\d{2}([A-Z]{0,2}$))))
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ (re.range "A" "Z") (re.union (re.++ ((_ re.loop 0 9) (re.range "0" "9")) (str.to_re "")) (re.++ ((_ re.loop 9 9) (re.range "0" "9")) (re.union (re.++ ((_ re.loop 0 6) (re.range "A" "Z")) (str.to_re "")) (re.++ ((_ re.loop 6 6) (re.range "A" "Z")) (re.union (re.++ ((_ re.loop 0 2) (re.range "0" "9")) (str.to_re "")) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ ((_ re.loop 0 2) (re.range "A" "Z")) (str.to_re ""))))))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)