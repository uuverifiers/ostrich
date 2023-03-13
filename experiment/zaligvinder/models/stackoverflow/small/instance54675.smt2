;test regex ^(73[4-9]|7[4-9]\d|[89]\d\d|\d{4,})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union (re.union (re.++ (str.to_re "73") (re.range "4" "9")) (re.++ (str.to_re "7") (re.++ (re.range "4" "9") (re.range "0" "9")))) (re.++ (str.to_re "89") (re.++ (re.range "0" "9") (re.range "0" "9")))) (re.++ (re.* (re.range "0" "9")) ((_ re.loop 4 4) (re.range "0" "9"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)