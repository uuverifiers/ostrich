;test regex ^(((0|[1-9]\d{0,5})(\,\d{2})?)|(1000000(\,00)?))$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.++ (re.union (str.to_re "0") (re.++ (re.range "1" "9") ((_ re.loop 0 5) (re.range "0" "9")))) (re.opt (re.++ (str.to_re ",") ((_ re.loop 2 2) (re.range "0" "9"))))) (re.++ (str.to_re "1000000") (re.opt (re.++ (str.to_re ",") (str.to_re "00")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)