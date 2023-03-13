;test regex ^(?:0|\d{5,6}|2[5-9]\d\d|[3-9]\d\d\d)$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union (re.union (str.to_re "0") ((_ re.loop 5 6) (re.range "0" "9"))) (re.++ (str.to_re "2") (re.++ (re.range "5" "9") (re.++ (re.range "0" "9") (re.range "0" "9"))))) (re.++ (re.range "3" "9") (re.++ (re.range "0" "9") (re.++ (re.range "0" "9") (re.range "0" "9")))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)