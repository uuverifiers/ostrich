;test regex ^[1-9]{1}(|[0-9])\-([A-HJ-NP-Z]{3}[A-D]{3}|[A-HJ-NP-Z]{3}|[A-D]{3})
(declare-const X String)
(assert (str.in_re X (re.++ (str.to_re "") (re.++ ((_ re.loop 1 1) (re.range "1" "9")) (re.++ (re.union (str.to_re "") (re.++ (str.to_re "") (re.range "0" "9"))) (re.++ (str.to_re "-") (re.union (re.union (re.++ ((_ re.loop 3 3) (re.union (re.range "A" "H") (re.union (re.range "J" "N") (re.range "P" "Z")))) ((_ re.loop 3 3) (re.range "A" "D"))) ((_ re.loop 3 3) (re.union (re.range "A" "H") (re.union (re.range "J" "N") (re.range "P" "Z"))))) ((_ re.loop 3 3) (re.range "A" "D")))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)