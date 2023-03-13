;test regex ^([378][0-9]{3}|5([0-8][0-9]{2}|900))$
(declare-const X String)
(assert (str.in_re X (re.++ (re.++ (str.to_re "") (re.union (re.++ (str.to_re "378") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (str.to_re "5") (re.union (re.++ (re.range "0" "8") ((_ re.loop 2 2) (re.range "0" "9"))) (str.to_re "900"))))) (str.to_re ""))))
; sanitize danger characters:  < > ' " \ / &
(assert (not (str.in_re X (re.* (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "\u{2f}") (str.to_re "\u{26}"))))))
(assert (< 20 (str.len X)))
(check-sat)
(get-model)