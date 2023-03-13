;test regex ([a-zA-Z]|[0-9]{1,4}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])
(declare-const X String)
(assert (str.in_re X (re.union (re.union (re.union (re.union (re.union (re.union (re.union (re.range "a" "z") (re.range "A" "Z")) ((_ re.loop 1 4) (re.range "0" "9"))) (re.++ (re.range "1" "5") ((_ re.loop 4 4) (re.range "0" "9")))) (re.++ (str.to_re "6") (re.++ (re.range "0" "4") ((_ re.loop 3 3) (re.range "0" "9"))))) (re.++ (str.to_re "65") (re.++ (re.range "0" "4") ((_ re.loop 2 2) (re.range "0" "9"))))) (re.++ (str.to_re "655") (re.++ (re.range "0" "2") (re.range "0" "9")))) (re.++ (str.to_re "6553") (re.range "0" "5")))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)