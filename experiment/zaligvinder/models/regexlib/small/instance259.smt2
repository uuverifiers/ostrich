;test regex (^(352)[8-9](\d{11}$|\d{12}$))|(^(35)[3-8](\d{12}$|\d{13}$))
(declare-const X String)
(assert (str.in_re X (re.union (re.++ (str.to_re "") (re.++ (str.to_re "352") (re.++ (re.range "8" "9") (re.union (re.++ ((_ re.loop 11 11) (re.range "0" "9")) (str.to_re "")) (re.++ ((_ re.loop 12 12) (re.range "0" "9")) (str.to_re "")))))) (re.++ (str.to_re "") (re.++ (str.to_re "35") (re.++ (re.range "3" "8") (re.union (re.++ ((_ re.loop 12 12) (re.range "0" "9")) (str.to_re "")) (re.++ ((_ re.loop 13 13) (re.range "0" "9")) (str.to_re "")))))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)