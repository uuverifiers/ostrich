;test regex  \A[1-9][0-9]{3}([A-RT-Z][A-Z])|([S]([BC]|[E-R]|[T-Z]))\z
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re " ") (re.++ (str.to_re "A") (re.++ (re.range "1" "9") (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.++ (re.union (re.range "A" "R") (re.range "T" "Z")) (re.range "A" "Z")))))) (re.++ (re.++ (str.to_re "S") (re.union (re.union (re.union (str.to_re "B") (str.to_re "C")) (re.range "E" "R")) (re.range "T" "Z"))) (str.to_re "z")))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)