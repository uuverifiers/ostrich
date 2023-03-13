;test regex ^[A-Z]{6}[0-9]{2}[A-E,H,L,M,P,R-T][0-9]{2}[A-Z0-9]{5}$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ ((_ re.loop 6 6) (re.range "A" "Z")) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (re.union (re.range "A" "E") (re.union (str.to_re ",") (re.union (str.to_re "H") (re.union (str.to_re ",") (re.union (str.to_re "L") (re.union (str.to_re ",") (re.union (str.to_re "M") (re.union (str.to_re ",") (re.union (str.to_re "P") (re.union (str.to_re ",") (re.range "R" "T"))))))))))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 5 5) (re.union (re.range "A" "Z") (re.range "0" "9")))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)