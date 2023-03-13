;test regex ^[0-9]{10}GBR[0-9]{7}[U,M,F]{1}[0-9]{9}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 10 10) (re.range "0" "9")) (re.++ (str.to_re "G") (re.++ (str.to_re "B") (re.++ (str.to_re "R") (re.++ ((_ re.loop 7 7) (re.range "0" "9")) (re.++ ((_ re.loop 1 1) (re.union (str.to_re "U") (re.union (str.to_re ",") (re.union (str.to_re "M") (re.union (str.to_re ",") (str.to_re "F")))))) ((_ re.loop 9 9) (re.range "0" "9"))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)