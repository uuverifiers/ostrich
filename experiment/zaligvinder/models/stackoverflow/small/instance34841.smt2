;test regex ^(?:102[4-9]|10[3-9]\d|1[1-9]\d{2}|[2-9]\d{3}|[1-5]\d{4}|6[0-4]\d{3}|65[0-4]\d{2}|655[0-2]\d|6553[0-5])$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.++ (str.to_re "102") (re.range "4" "9")) (re.++ (str.to_re "10") (re.++ (re.range "3" "9") (re.range "0" "9")))) (re.++ (str.to_re "1") (re.++ (re.range "1" "9") ((_ re.loop 2 2) (re.range "0" "9"))))) (re.++ (re.range "2" "9") ((_ re.loop 3 3) (re.range "0" "9")))) (re.++ (re.range "1" "5") ((_ re.loop 4 4) (re.range "0" "9")))) (re.++ (str.to_re "6") (re.++ (re.range "0" "4") ((_ re.loop 3 3) (re.range "0" "9"))))) (re.++ (str.to_re "65") (re.++ (re.range "0" "4") ((_ re.loop 2 2) (re.range "0" "9"))))) (re.++ (str.to_re "655") (re.++ (re.range "0" "2") (re.range "0" "9")))) (re.++ (str.to_re "6553") (re.range "0" "5")))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)