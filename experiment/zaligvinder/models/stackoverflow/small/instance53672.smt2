;test regex (ANY|1-9|[A-Za-z0-9]|[1-9]\d{1,2})
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.++ (str.to_re "A") (re.++ (str.to_re "N") (str.to_re "Y"))) (re.++ (str.to_re "1") (re.++ (str.to_re "-") (str.to_re "9")))) (re.union (re.range "A" "Z") (re.union (re.range "a" "z") (re.range "0" "9")))) (re.++ (re.range "1" "9") ((_ re.loop 1 2) (re.range "0" "9"))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)