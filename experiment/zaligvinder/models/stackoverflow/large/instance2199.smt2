;test regex \D([0-9]{12}|[0-9]{15}|[0-9]{20}|[0-9]{22})\D
(declare-const X String)
(assert (str.in_re X (re.++ (re.diff re.allchar (re.range "0" "9")) (re.++ (re.union (re.union (re.union ((_ re.loop 12 12) (re.range "0" "9")) ((_ re.loop 15 15) (re.range "0" "9"))) ((_ re.loop 20 20) (re.range "0" "9"))) ((_ re.loop 22 22) (re.range "0" "9"))) (re.diff re.allchar (re.range "0" "9"))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 50 (str.len X)))
(check-sat)
(get-model)