;test regex ^[NS]([0-8][0-9](\.[0-5]\d){2}|90(\.00){2})\040[EW]((0\d\d|1[0-7]\d)(\.[0-5]\d){2}|180(\.00){2})$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.++ (re.union (str.to_re "N") (str.to_re "S")) (re.++ (re.union (re.++ (re.range "0" "8") (re.++ (re.range "0" "9") ((_ re.loop 2 2) (re.++ (str.to_re ".") (re.++ (re.range "0" "5") (re.range "0" "9")))))) (re.++ (str.to_re "90") ((_ re.loop 2 2) (re.++ (str.to_re ".") (str.to_re "00"))))) (re.++ (str.to_re "\u{0020}") (re.++ (re.union (str.to_re "E") (str.to_re "W")) (re.union (re.++ (re.union (re.++ (str.to_re "0") (re.++ (re.range "0" "9") (re.range "0" "9"))) (re.++ (str.to_re "1") (re.++ (re.range "0" "7") (re.range "0" "9")))) ((_ re.loop 2 2) (re.++ (str.to_re ".") (re.++ (re.range "0" "5") (re.range "0" "9"))))) (re.++ (str.to_re "180") ((_ re.loop 2 2) (re.++ (str.to_re ".") (str.to_re "00")))))))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)