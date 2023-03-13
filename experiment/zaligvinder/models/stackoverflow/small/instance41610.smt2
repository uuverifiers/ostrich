;test regex \d{1,3}(?:k|rb|ribu|(?:[,.]\d{3})+|\d+)
(declare-const X String)
(assert (str.in_re X (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.union (re.union (re.union (re.union (str.to_re "k") (re.++ (str.to_re "r") (str.to_re "b"))) (re.++ (str.to_re "r") (re.++ (str.to_re "i") (re.++ (str.to_re "b") (str.to_re "u"))))) (re.+ (re.++ (re.union (str.to_re ",") (str.to_re ".")) ((_ re.loop 3 3) (re.range "0" "9"))))) (re.+ (re.range "0" "9"))))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)