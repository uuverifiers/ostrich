;test regex @"^(090|091|0123|0168|0199|0124)\d{7,8}$"
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (re.++ (str.to_re "@") (str.to_re "\u{22}")) (re.++ (str.to_re "") (re.++ (re.union (re.union (re.union (re.union (re.union (str.to_re "090") (str.to_re "091")) (str.to_re "0123")) (str.to_re "0168")) (str.to_re "0199")) (str.to_re "0124")) ((_ re.loop 7 8) (re.range "0" "9"))))) (re.++ (str.to_re "") (str.to_re "\u{22}")))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)