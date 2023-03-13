;test regex ^[S][STWXV]/d{6}[A-Z0-9]{2}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (str.to_re "S") (re.++ (re.union (str.to_re "S") (re.union (str.to_re "T") (re.union (str.to_re "W") (re.union (str.to_re "X") (str.to_re "V"))))) (re.++ (str.to_re "/") (re.++ ((_ re.loop 6 6) (str.to_re "d")) ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "0" "9")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)